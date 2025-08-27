# 珠海优美官网 - Docker完整部署方案

## 🐳 Docker部署概览

使用Docker Compose进行一键容器化部署，包含前端、后端、数据库、缓存的完整服务栈。

### 容器架构
```
┌─────────────────┐    ┌─────────────────┐
│   Nginx Proxy   │────│   Vue Frontend  │
│   (Port: 80/443)│    │   (Port: 3000)  │
└─────────────────┘    └─────────────────┘
         │
         ▼
┌─────────────────┐    ┌─────────────────┐
│ Django Backend  │────│   PostgreSQL    │
│  (Port: 8000)   │    │   (Port: 5432)  │
└─────────────────┘    └─────────────────┘
         │
         ▼
┌─────────────────┐
│     Redis       │
│   (Port: 6379)  │
└─────────────────┘
```

---

## 📁 1. 项目目录结构

```bash
zhuhai-youmei-docker/
├── docker-compose.yml          # Docker Compose主配置
├── docker-compose.prod.yml     # 生产环境配置
├── .env                        # 环境变量
├── nginx/
│   ├── Dockerfile             # Nginx容器配置
│   ├── nginx.conf             # Nginx主配置
│   └── default.conf           # 站点配置
├── backend/
│   ├── Dockerfile             # Django容器配置
│   ├── requirements.txt       # Python依赖
│   ├── entrypoint.sh         # 容器启动脚本
│   └── zhuhai_youmei/        # Django项目代码
├── frontend/
│   ├── Dockerfile             # Vue容器配置
│   ├── package.json           # Node.js依赖
│   └── src/                   # Vue项目代码
├── postgres/
│   └── init.sql              # 数据库初始化脚本
├── scripts/
│   ├── deploy.sh             # 部署脚本
│   ├── backup.sh             # 备份脚本
│   └── logs.sh               # 日志查看脚本
└── volumes/                   # 数据持久化目录
    ├── postgres/
    ├── media/
    └── static/
```

---

## 📦 2. Docker配置文件

### 2.1 主要的 docker-compose.yml
```yaml
version: '3.8'

services:
  # PostgreSQL数据库
  postgres:
    image: postgres:15-alpine
    container_name: zhuhai-postgres
    restart: unless-stopped
    environment:
      POSTGRES_DB: ${DB_NAME:-zhuhai_youmei}
      POSTGRES_USER: ${DB_USER:-youmei_user}
      POSTGRES_PASSWORD: ${DB_PASSWORD}
      POSTGRES_INITDB_ARGS: "--encoding=UTF-8 --lc-collate=C --lc-ctype=C"
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./postgres/init.sql:/docker-entrypoint-initdb.d/init.sql
    ports:
      - "5432:5432"
    networks:
      - zhuhai-network
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${DB_USER:-youmei_user}"]
      interval: 30s
      timeout: 10s
      retries: 3

  # Redis缓存
  redis:
    image: redis:7-alpine
    container_name: zhuhai-redis
    restart: unless-stopped
    command: redis-server --requirepass ${REDIS_PASSWORD}
    volumes:
      - redis_data:/data
    ports:
      - "6379:6379"
    networks:
      - zhuhai-network
    healthcheck:
      test: ["CMD", "redis-cli", "--raw", "incr", "ping"]
      interval: 30s
      timeout: 10s
      retries: 3

  # Django后端
  backend:
    build:
      context: ./backend
      dockerfile: Dockerfile
    container_name: zhuhai-backend
    restart: unless-stopped
    environment:
      - DEBUG=${DEBUG:-False}
      - SECRET_KEY=${SECRET_KEY}
      - DB_HOST=postgres
      - DB_NAME=${DB_NAME:-zhuhai_youmei}
      - DB_USER=${DB_USER:-youmei_user}
      - DB_PASSWORD=${DB_PASSWORD}
      - REDIS_URL=redis://redis:6379/0
      - REDIS_PASSWORD=${REDIS_PASSWORD}
      - ALLOWED_HOSTS=${ALLOWED_HOSTS}
      - CORS_ALLOWED_ORIGINS=${CORS_ALLOWED_ORIGINS}
    volumes:
      - ./backend:/app
      - static_volume:/app/staticfiles
      - media_volume:/app/media
    ports:
      - "8000:8000"
    depends_on:
      postgres:
        condition: service_healthy
      redis:
        condition: service_healthy
    networks:
      - zhuhai-network
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8000/health/"]
      interval: 30s
      timeout: 10s
      retries: 3

  # Vue前端
  frontend:
    build:
      context: ./frontend
      dockerfile: Dockerfile
      args:
        - VITE_API_BASE_URL=${VITE_API_BASE_URL}
    container_name: zhuhai-frontend
    restart: unless-stopped
    volumes:
      - frontend_dist:/app/dist
    depends_on:
      - backend
    networks:
      - zhuhai-network

  # Nginx反向代理
  nginx:
    build:
      context: ./nginx
      dockerfile: Dockerfile
    container_name: zhuhai-nginx
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - static_volume:/static
      - media_volume:/media
      - frontend_dist:/frontend
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf
      - ./nginx/default.conf:/etc/nginx/conf.d/default.conf
      - ./ssl:/etc/nginx/ssl
    depends_on:
      - backend
      - frontend
    networks:
      - zhuhai-network
    healthcheck:
      test: ["CMD", "nginx", "-t"]
      interval: 30s
      timeout: 10s
      retries: 3

volumes:
  postgres_data:
  redis_data:
  static_volume:
  media_volume:
  frontend_dist:

networks:
  zhuhai-network:
    driver: bridge
```

### 2.2 生产环境配置 docker-compose.prod.yml
```yaml
version: '3.8'

services:
  postgres:
    restart: always
    deploy:
      resources:
        limits:
          memory: 1G
        reservations:
          memory: 512M

  redis:
    restart: always
    deploy:
      resources:
        limits:
          memory: 256M
        reservations:
          memory: 128M

  backend:
    restart: always
    environment:
      - DEBUG=False
      - DJANGO_SETTINGS_MODULE=zhuhai_youmei.settings.production
    deploy:
      resources:
        limits:
          memory: 1G
        reservations:
          memory: 512M
      replicas: 2

  nginx:
    restart: always
    deploy:
      resources:
        limits:
          memory: 256M
        reservations:
          memory: 128M

  # 日志收集 (可选)
  logspout:
    image: gliderlabs/logspout:latest
    container_name: zhuhai-logspout
    restart: unless-stopped
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    environment:
      - SYSLOG_FORMAT=rfc3164
    networks:
      - zhuhai-network
```

### 2.3 环境变量文件 .env
```bash
# 基础配置
COMPOSE_PROJECT_NAME=zhuhai-youmei
COMPOSE_FILE=docker-compose.yml:docker-compose.prod.yml

# Django配置
DEBUG=False
SECRET_KEY=your-very-long-and-random-secret-key-here
ALLOWED_HOSTS=your-domain.com,www.your-domain.com,localhost
CORS_ALLOWED_ORIGINS=https://your-domain.com,https://www.your-domain.com

# 数据库配置
DB_NAME=zhuhai_youmei
DB_USER=youmei_user
DB_PASSWORD=your-strong-database-password

# Redis配置
REDIS_PASSWORD=your-redis-password

# 前端配置
VITE_API_BASE_URL=https://api.your-domain.com

# SSL配置
SSL_EMAIL=your-email@example.com
DOMAIN=your-domain.com

# 备份配置
BACKUP_SCHEDULE=0 2 * * *
BACKUP_RETENTION_DAYS=30
```

---

## 🐳 3. Dockerfile配置

### 3.1 Django后端 Dockerfile
```dockerfile
# backend/Dockerfile
FROM python:3.11-slim

# 设置环境变量
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV DJANGO_SETTINGS_MODULE=zhuhai_youmei.settings

# 设置工作目录
WORKDIR /app

# 安装系统依赖
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        libpq-dev \
        curl \
        netcat-openbsd \
    && rm -rf /var/lib/apt/lists/*

# 安装Python依赖
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 复制项目代码
COPY . .

# 创建非root用户
RUN adduser --disabled-password --gecos '' appuser \
    && chown -R appuser:appuser /app
USER appuser

# 创建必要目录
RUN mkdir -p /app/staticfiles /app/media /app/logs

# 复制启动脚本
COPY entrypoint.sh /app/
RUN chmod +x /app/entrypoint.sh

# 暴露端口
EXPOSE 8000

# 健康检查
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8000/health/ || exit 1

# 启动命令
ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "3", "--timeout", "60", "zhuhai_youmei.wsgi:application"]
```

### 3.2 Vue前端 Dockerfile
```dockerfile
# frontend/Dockerfile
# 构建阶段
FROM node:20-alpine as builder

WORKDIR /app

# 安装Bun
RUN npm install -g bun

# 复制依赖文件
COPY package.json bun.lockb ./

# 安装依赖
RUN bun install --frozen-lockfile

# 复制源代码
COPY . .

# 构建参数
ARG VITE_API_BASE_URL
ENV VITE_API_BASE_URL=$VITE_API_BASE_URL

# 构建应用
RUN bun run build

# 生产阶段
FROM nginx:alpine

# 复制构建产物
COPY --from=builder /app/dist /usr/share/nginx/html

# 复制Nginx配置
COPY nginx.conf /etc/nginx/conf.d/default.conf

# 创建非root用户
RUN addgroup -g 1001 -S nginx \
    && adduser -S -D -H -u 1001 -h /var/cache/nginx -s /sbin/nologin -G nginx -g nginx nginx

# 设置权限
RUN chown -R nginx:nginx /usr/share/nginx/html \
    && chown -R nginx:nginx /var/cache/nginx \
    && chown -R nginx:nginx /var/log/nginx \
    && chown -R nginx:nginx /etc/nginx/conf.d \
    && touch /var/run/nginx.pid \
    && chown -R nginx:nginx /var/run/nginx.pid

USER nginx

# 暴露端口
EXPOSE 80

# 健康检查
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost/ || exit 1

# 启动命令
CMD ["nginx", "-g", "daemon off;"]
```

### 3.3 Nginx Dockerfile
```dockerfile
# nginx/Dockerfile
FROM nginx:alpine

# 安装certbot (用于SSL证书)
RUN apk add --no-cache certbot certbot-nginx

# 复制配置文件
COPY nginx.conf /etc/nginx/nginx.conf
COPY default.conf /etc/nginx/conf.d/default.conf

# 创建必要目录
RUN mkdir -p /etc/nginx/ssl /var/log/nginx

# 创建非root用户
RUN addgroup -g 1001 -S nginx \
    && adduser -S -D -H -u 1001 -h /var/cache/nginx -s /sbin/nologin -G nginx -g nginx nginx

# 设置权限
RUN chown -R nginx:nginx /var/cache/nginx \
    && chown -R nginx:nginx /var/log/nginx \
    && chown -R nginx:nginx /etc/nginx \
    && touch /var/run/nginx.pid \
    && chown -R nginx:nginx /var/run/nginx.pid

# 暴露端口
EXPOSE 80 443

# 健康检查
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD nginx -t || exit 1

# 启动命令
CMD ["nginx", "-g", "daemon off;"]
```

---

## ⚙️ 4. 配置文件

### 4.1 Django entrypoint.sh
```bash
#!/bin/bash
# backend/entrypoint.sh

set -e

echo "🚀 启动Django应用..."

# 等待数据库就绪
echo "⏳ 等待PostgreSQL..."
while ! nc -z postgres 5432; do
  sleep 1
done
echo "✅ PostgreSQL已就绪"

# 等待Redis就绪
echo "⏳ 等待Redis..."
while ! nc -z redis 6379; do
  sleep 1
done
echo "✅ Redis已就绪"

# 执行数据库迁移
echo "🗄️ 执行数据库迁移..."
python manage.py migrate --noinput

# 收集静态文件
echo "📁 收集静态文件..."
python manage.py collectstatic --noinput

# 创建超级用户 (仅在开发环境)
if [ "$DEBUG" = "True" ]; then
    echo "👤 创建超级用户..."
    python manage.py shell -c "
from django.contrib.auth.models import User
import os
if not User.objects.filter(username='admin').exists():
    User.objects.create_superuser('admin', 'admin@example.com', os.environ.get('ADMIN_PASSWORD', 'admin123'))
    print('超级用户已创建: admin/admin123')
"
fi

# 启动应用
echo "🌟 启动Django应用..."
exec "$@"
```

### 4.2 Nginx配置 nginx/nginx.conf
```nginx
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log warn;
pid /var/run/nginx.pid;

events {
    worker_connections 1024;
    use epoll;
    multi_accept on;
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    # 日志格式
    log_format main '$remote_addr - $remote_user [$time_local] "$request" '
                    '$status $body_bytes_sent "$http_referer" '
                    '"$http_user_agent" "$http_x_forwarded_for"';

    access_log /var/log/nginx/access.log main;

    # 基础配置
    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    types_hash_max_size 2048;
    client_max_body_size 100M;

    # Gzip压缩
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_comp_level 6;
    gzip_types
        text/plain
        text/css
        text/xml
        text/javascript
        application/json
        application/javascript
        application/xml+rss
        application/atom+xml
        image/svg+xml;

    # 安全headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Referrer-Policy "no-referrer-when-downgrade" always;

    # 包含站点配置
    include /etc/nginx/conf.d/*.conf;
}
```

### 4.3 Nginx站点配置 nginx/default.conf
```nginx
# 上游服务器定义
upstream django {
    server backend:8000;
}

# HTTP重定向到HTTPS
server {
    listen 80;
    server_name your-domain.com www.your-domain.com api.your-domain.com;

    # 处理Let's Encrypt证书验证
    location /.well-known/acme-challenge/ {
        root /var/www/certbot;
    }

    # 其他请求重定向到HTTPS
    location / {
        return 301 https://$host$request_uri;
    }
}

# 主站点 (前端)
server {
    listen 443 ssl http2;
    server_name your-domain.com www.your-domain.com;

    # SSL配置
    ssl_certificate /etc/nginx/ssl/fullchain.pem;
    ssl_certificate_key /etc/nginx/ssl/privkey.pem;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384;
    ssl_prefer_server_ciphers off;

    # 前端静态文件
    root /frontend;
    index index.html;

    # 处理Vue Router的history模式
    location / {
        try_files $uri $uri/ /index.html;
    }

    # 静态资源缓存
    location ~* \.(css|js|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}

# API站点 (后端)
server {
    listen 443 ssl http2;
    server_name api.your-domain.com;

    # SSL配置
    ssl_certificate /etc/nginx/ssl/fullchain.pem;
    ssl_certificate_key /etc/nginx/ssl/privkey.pem;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384;
    ssl_prefer_server_ciphers off;

    # Django静态文件
    location /static/ {
        alias /static/;
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    # Django媒体文件
    location /media/ {
        alias /media/;
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    # API代理
    location / {
        proxy_pass http://django;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_redirect off;

        # CORS headers
        add_header Access-Control-Allow-Origin "https://your-domain.com" always;
        add_header Access-Control-Allow-Methods "GET, POST, PUT, DELETE, OPTIONS" always;
        add_header Access-Control-Allow-Headers "Origin, Content-Type, Accept, Authorization" always;

        if ($request_method = 'OPTIONS') {
            return 204;
        }
    }
}
```

---

## 🚀 5. 部署脚本

### 5.1 主部署脚本 scripts/deploy.sh
```bash
#!/bin/bash
# scripts/deploy.sh

set -e

echo "🐳 开始Docker部署珠海优美官网..."

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 检查Docker和Docker Compose
check_requirements() {
    echo "🔍 检查系统要求..."

    if ! command -v docker &> /dev/null; then
        echo -e "${RED}❌ Docker未安装${NC}"
        exit 1
    fi

    if ! command -v docker-compose &> /dev/null; then
        echo -e "${RED}❌ Docker Compose未安装${NC}"
        exit 1
    fi

    echo -e "${GREEN}✅ 系统要求检查通过${NC}"
}

# 环境检查
check_environment() {
    if [ ! -f .env ]; then
        echo -e "${YELLOW}⚠️ 未找到.env文件，正在创建示例文件...${NC}"
        cp .env.example .env
        echo -e "${YELLOW}请编辑.env文件后重新运行部署脚本${NC}"
        exit 1
    fi

    source .env

    if [ -z "$SECRET_KEY" ] || [ -z "$DB_PASSWORD" ] || [ -z "$REDIS_PASSWORD" ]; then
        echo -e "${RED}❌ 请在.env文件中设置必要的环境变量${NC}"
        exit 1
    fi
}

# 创建必要目录
create_directories() {
    echo "📁 创建必要目录..."
    mkdir -p volumes/{postgres,media,static,ssl}
    mkdir -p logs
}

# 构建镜像
build_images() {
    echo "🔨 构建Docker镜像..."
    docker-compose build --no-cache
}

# 启动服务
start_services() {
    echo "🚀 启动服务..."
    docker-compose up -d

    echo "⏳ 等待服务启动..."
    sleep 30

    # 检查服务状态
    docker-compose ps
}

# 初始化数据
initialize_data() {
    echo "📊 初始化数据..."

    # 创建超级用户
    docker-compose exec -T backend python manage.py shell << EOF
from django.contrib.auth.models import User
import os
if not User.objects.filter(username='admin').exists():
    User.objects.create_superuser('admin', 'admin@example.com', '${ADMIN_PASSWORD:-admin123}')
    print('超级用户已创建')
EOF

    # 加载示例数据 (可选)
    if [ -f fixtures/sample_data.json ]; then
        echo "📄 加载示例数据..."
        docker-compose exec -T backend python manage.py loaddata fixtures/sample_data.json
    fi
}

# SSL证书配置
setup_ssl() {
    if [ "$DOMAIN" != "your-domain.com" ]; then
        echo "🔒 配置SSL证书..."

        # 停止nginx容器
        docker-compose stop nginx

        # 申请证书
        docker run --rm -v "${PWD}/volumes/ssl:/etc/letsencrypt" \
            -v "${PWD}/volumes/ssl/www:/var/www/certbot" \
            certbot/certbot certonly \
            --webroot \
            --webroot-path=/var/www/certbot \
            --email ${SSL_EMAIL} \
            --agree-tos \
            --no-eff-email \
            -d ${DOMAIN} \
            -d www.${DOMAIN} \
            -d api.${DOMAIN}

        # 复制证书到nginx目录
        cp volumes/ssl/live/${DOMAIN}/fullchain.pem volumes/ssl/
        cp volumes/ssl/live/${DOMAIN}/privkey.pem volumes/ssl/

        # 重启nginx
        docker-compose start nginx
    else
        echo -e "${YELLOW}⚠️ 请在.env文件中设置正确的域名以配置SSL${NC}"
    fi
}

# 健康检查
health_check() {
    echo "🏥 执行健康检查..."

    # 检查后端
    if curl -f http://localhost:8000/health/ > /dev/null 2>&1; then
        echo -e "${GREEN}✅ 后端服务正常${NC}"
    else
        echo -e "${RED}❌ 后端服务异常${NC}"
        docker-compose logs backend
    fi

    # 检查前端
    if curl -f http://localhost/ > /dev/null 2>&1; then
        echo -e "${GREEN}✅ 前端服务正常${NC}"
    else
        echo -e "${RED}❌ 前端服务异常${NC}"
        docker-compose logs nginx
    fi

    # 检查数据库
    if docker-compose exec -T postgres pg_isready -U ${DB_USER} > /dev/null 2>&1; then
        echo -e "${GREEN}✅ 数据库服务正常${NC}"
    else
        echo -e "${RED}❌ 数据库服务异常${NC}"
        docker-compose logs postgres
    fi
}

# 显示部署信息
show_info() {
    echo -e "${GREEN}"
    echo "🎉 部署完成！"
    echo "=========================="
    echo "前端地址: http://localhost"
    echo "API地址: http://localhost:8000"
    echo "管理后台: http://localhost:8000/admin/"
    echo "数据库: localhost:5432"
    echo "Redis: localhost:6379"
    echo ""
    echo "管理员账号: admin"
    echo "管理员密码: ${ADMIN_PASSWORD:-admin123}"
    echo ""
    echo "查看日志: docker-compose logs -f"
    echo "停止服务: docker-compose down"
    echo "重启服务: docker-compose restart"
    echo -e "${NC}"
}

# 主函数
main() {
    check_requirements
    check_environment
    create_directories
    build_images
    start_services
    initialize_data
    setup_ssl
    health_check
    show_info
}

# 参数处理
case "${1:-deploy}" in
    deploy)
        main
        ;;
    build)
        build_images
        ;;
    start)
        start_services
        ;;
    stop)
        docker-compose down
        ;;
    restart)
        docker-compose restart
        ;;
    logs)
        docker-compose logs -f ${2:-}
        ;;
    health)
        health_check
        ;;
    *)
        echo "Usage: $0 {deploy|build|start|stop|restart|logs|health}"
        exit 1
        ;;
esac
```

### 5.2 备份脚本 scripts/backup.sh
```bash
#!/bin/bash
# scripts/backup.sh

set -e

BACKUP_DIR="./backups"
DATE=$(date +%Y%m%d_%H%M%S)
PROJECT_NAME="zhuhai-youmei"

# 创建备份目录
mkdir -p $BACKUP_DIR

echo "🗄️ 开始备份..."

# 数据库备份
echo "📊 备份数据库..."
docker-compose exec -T postgres pg_dump -U ${DB_USER:-youmei_user} ${DB_NAME:-zhuhai_youmei} > $BACKUP_DIR/db_backup_$DATE.sql

# 媒体文件备份
echo "📁 备份媒体文件..."
docker run --rm -v ${PWD}/volumes/media:/source -v ${PWD}/$BACKUP_DIR:/backup alpine tar -czf /backup/media_backup_$DATE.tar.gz -C /source .

# 配置文件备份
echo "⚙️ 备份配置文件..."
tar -czf $BACKUP_DIR/config_backup_$DATE.tar.gz .env docker-compose*.yml nginx/ postgres/

# 清理旧备份 (保留7天)
find $BACKUP_DIR -name "*backup_*" -mtime +7 -delete

echo "✅ 备份完成到: $BACKUP_DIR"
echo "📁 数据库: db_backup_$DATE.sql"
echo "📁 媒体文件: media_backup_$DATE.tar.gz"
echo "📁 配置文件: config_backup_$DATE.tar.gz"
```

### 5.3 日志查看脚本 scripts/logs.sh
```bash
#!/bin/bash
# scripts/logs.sh

case "${1:-all}" in
    all)
        docker-compose logs -f
        ;;
    backend)
        docker-compose logs -f backend
        ;;
    frontend)
        docker-compose logs -f frontend
        ;;
    nginx)
        docker-compose logs -f nginx
        ;;
    postgres)
        docker-compose logs -f postgres
        ;;
    redis)
        docker-compose logs -f redis
        ;;
    *)
        echo "Usage: $0 {all|backend|frontend|nginx|postgres|redis}"
        echo "查看指定服务的日志"
        ;;
esac
```

---

## 📋 6. 快速部署指南

### 6.1 一键部署
```bash
# 1. 克隆项目
git clone https://github.com/your-username/zhuhai-youmei-docker.git
cd zhuhai-youmei-docker

# 2. 配置环境变量
cp .env.example .env
nano .env  # 编辑环境变量

# 3. 一键部署
chmod +x scripts/deploy.sh
./scripts/deploy.sh
```

### 6.2 生产环境部署
```bash
# 使用生产环境配置
export COMPOSE_FILE=docker-compose.yml:docker-compose.prod.yml

# 部署
./scripts/deploy.sh

# 配置SSL (需要域名)
./scripts/ssl.sh setup
```

---

## 🔧 7. 运维命令

### 7.1 常用命令
```bash
# 查看服务状态
docker-compose ps

# 查看资源使用
docker stats

# 进入容器
docker-compose exec backend bash
docker-compose exec postgres psql -U youmei_user -d zhuhai_youmei

# 重启服务
docker-compose restart backend
docker-compose restart nginx

# 查看日志
./scripts/logs.sh backend
./scripts/logs.sh nginx

# 备份数据
./scripts/backup.sh

# 更新代码
git pull
docker-compose build
docker-compose up -d
```

### 7.2 故障排除
```bash
# 检查容器状态
docker-compose ps

# 查看容器日志
docker-compose logs backend

# 重建容器
docker-compose up -d --force-recreate backend

# 清理未使用的镜像
docker system prune -a
```

---

## 📊 8. 监控和维护

### 8.1 容器监控
```yaml
# 添加到docker-compose.yml
  portainer:
    image: portainer/portainer-ce:latest
    container_name: portainer
    restart: unless-stopped
    ports:
      - "9000:9000"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - portainer_data:/data

  watchtower:
    image: containrrr/watchtower
    container_name: watchtower
    restart: unless-stopped
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    environment:
      - WATCHTOWER_SCHEDULE=0 0 2 * * *  # 每天凌晨2点检查更新
```

### 8.2 日志管理
```bash
# 配置日志轮转
# /etc/docker/daemon.json
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  }
}
```

---

🎉 **Docker部署方案已完成！**

**核心优势:**
- 🚀 **一键部署**: 完整的容器化部署方案
- 🔒 **安全隔离**: 每个服务运行在独立容器中
- 📈 **易于扩展**: 支持水平扩展和负载均衡
- 🔧 **运维友好**: 丰富的监控和管理工具
- 💾 **数据持久化**: 数据卷确保数据安全

**部署命令:**
```bash
./scripts/deploy.sh       # 一键部署
./scripts/logs.sh all     # 查看所有日志
./scripts/backup.sh       # 数据备份
```
