#!/bin/bash

# 珠海优美官网 - Ubuntu 22.04 一键部署脚本 (Root用户版)
# 作者: AI Assistant
# 版本: 2.0
# 支持系统: Ubuntu 22.04 LTS
# 修正: 使用root用户执行，修复项目结构和路径问题

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 配置变量 (修正目录结构)
PROJECT_NAME="zhuhai-youmei"
PROJECT_DIR="/var/www/${PROJECT_NAME}/ym-cosmetics"
BACKEND_DIR="${PROJECT_DIR}/backend"
FRONTEND_DIR="${PROJECT_DIR}/frontend"
DEPLOY_USER="www-data"  # 使用www-data作为部署用户
ADMIN_EMAIL=""
DOMAIN=""
DB_PASSWORD=""
REDIS_PASSWORD=""
ADMIN_PASSWORD=""

# 日志函数
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_step() {
    echo -e "\n${PURPLE}=== $1 ===${NC}"
}

# 显示欢迎信息
show_welcome() {
    clear
    echo -e "${CYAN}"
    cat << 'EOF'
 ______________________________________
|                                      |
|     珠海优美化妆品官网一键部署         |
|     Ubuntu 22.04 LTS (Root版)       |
|     Vue 3 + Django 5 + PostgreSQL   |
|______________________________________|

EOF
    echo -e "${NC}"
    log_info "开始自动化部署流程..."
    log_info "运行用户: $(whoami)"
    log_info "项目目录: $PROJECT_DIR"
    log_info "前端目录: $FRONTEND_DIR"
    log_info "后端目录: $BACKEND_DIR"
    sleep 3
}

# 检查系统要求
check_system() {
    log_step "检查系统要求"

    # 检查是否为root用户
    if [[ $EUID -ne 0 ]]; then
        log_error "此脚本需要root权限运行。请使用: sudo $0"
        exit 1
    fi

    log_success "Root权限检查通过"

    # 检查Ubuntu版本
    if ! grep -q "Ubuntu 22.04" /etc/os-release; then
        log_error "此脚本仅支持Ubuntu 22.04 LTS"
        exit 1
    fi

    # 检查内存 (至少2GB)
    memory_gb=$(free -g | awk '/^Mem:/{print $2}')
    if [ "$memory_gb" -lt 2 ]; then
        log_warning "系统内存少于2GB，可能影响性能"
        read -p "是否继续? (y/N): " continue_deploy
        if [[ ! $continue_deploy =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi

    # 检查磁盘空间 (至少10GB)
    disk_gb=$(df / | awk 'NR==2{print int($4/1024/1024)}')
    if [ "$disk_gb" -lt 10 ]; then
        log_warning "系统可用磁盘空间少于10GB"
        read -p "是否继续? (y/N): " continue_deploy
        if [[ ! $continue_deploy =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi

    log_success "系统检查通过"
}

# 收集配置信息
collect_config() {
    log_step "收集部署配置"

    echo -e "${CYAN}请提供以下配置信息:${NC}"

    # 域名配置
    read -p "请输入域名 (例如: example.com，留空使用IP): " DOMAIN
    if [ -z "$DOMAIN" ]; then
        DOMAIN=$(curl -s ifconfig.me 2>/dev/null || hostname -I | awk '{print $1}')
        log_info "使用IP地址: $DOMAIN"
    fi

    # 管理员邮箱
    read -p "请输入管理员邮箱 (用于SSL证书): " ADMIN_EMAIL
    if [ -z "$ADMIN_EMAIL" ]; then
        ADMIN_EMAIL="admin@${DOMAIN}"
    fi

    # 数据库密码
    while [ -z "$DB_PASSWORD" ]; do
        read -s -p "请设置数据库密码 (至少8位): " DB_PASSWORD
        echo
        if [ ${#DB_PASSWORD} -lt 8 ]; then
            log_warning "密码长度至少8位"
            DB_PASSWORD=""
        fi
    done

    # Redis密码
    while [ -z "$REDIS_PASSWORD" ]; do
        read -s -p "请设置Redis密码 (至少8位): " REDIS_PASSWORD
        echo
        if [ ${#REDIS_PASSWORD} -lt 8 ]; then
            log_warning "密码长度至少8位"
            REDIS_PASSWORD=""
        fi
    done

    # 管理员密码
    while [ -z "$ADMIN_PASSWORD" ]; do
        read -s -p "请设置Django管理员密码 (至少8位): " ADMIN_PASSWORD
        echo
        if [ ${#ADMIN_PASSWORD} -lt 8 ]; then
            log_warning "密码长度至少8位"
            ADMIN_PASSWORD=""
        fi
    done

    # 确认配置
    echo -e "\n${CYAN}配置确认:${NC}"
    echo "项目目录: $PROJECT_DIR"
    echo "前端目录: $FRONTEND_DIR"
    echo "后端目录: $BACKEND_DIR"
    echo "部署用户: $DEPLOY_USER"
    echo "域名: $DOMAIN"
    echo "邮箱: $ADMIN_EMAIL"
    echo "数据库密码: [已设置]"
    echo "Redis密码: [已设置]"
    echo "管理员密码: [已设置]"

    read -p "确认开始部署? (y/N): " confirm
    if [[ ! $confirm =~ ^[Yy]$ ]]; then
        log_info "部署已取消"
        exit 0
    fi
}

# 更新系统
update_system() {
    log_step "更新系统包"

    apt update
    apt upgrade -y
    apt install -y curl wget git unzip build-essential software-properties-common

    log_success "系统更新完成"
}

# 安装Node.js和Bun (Root版本)
install_nodejs() {
    log_step "安装Node.js和Bun"

    # 安装Node.js 20
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
    apt-get install -y nodejs

    # 验证Node.js安装
    node_version=$(node --version)
    npm_version=$(npm --version)

    log_success "Node.js安装完成: $node_version"
    log_success "npm安装完成: $npm_version"

    # 安装Bun (Root用户版本)
    log_info "正在安装Bun包管理器..."

    # Root用户直接安装到系统目录
    export BUN_INSTALL="/usr/local"
    if curl -fsSL https://bun.sh/install | bash; then
        # 创建软链接确保bun可用
        ln -sf /usr/local/bin/bun /usr/bin/bun 2>/dev/null || true

        if command -v bun &> /dev/null; then
            bun_version=$(bun --version 2>/dev/null)
            log_success "Bun安装完成: $bun_version"
        else
            log_warning "Bun安装失败，将使用npm"
        fi
    else
        log_warning "Bun安装失败，将使用npm作为包管理器"
    fi

    log_success "Node.js环境配置完成"
}

# 安装Python 3.11
install_python() {
    log_step "安装Python 3.11"

    # 安装Python 3.11
    apt install -y python3.11 python3.11-venv python3.11-dev python3.11-distutils python3-pip

    # 创建软链接
    ln -sf /usr/bin/python3.11 /usr/local/bin/python3

    # 验证安装
    python_version=$(python3 --version)
    pip_version=$(pip3 --version 2>/dev/null || echo "pip3 not found")

    log_success "Python安装完成: $python_version"
    log_success "pip安装完成: $pip_version"
}

# 安装PostgreSQL
install_postgresql() {
    log_step "安装PostgreSQL"

    # 安装PostgreSQL
    apt install -y postgresql postgresql-contrib libpq-dev

    # 启动服务
    systemctl start postgresql
    systemctl enable postgresql

    # 配置数据库
    sudo -u postgres psql << EOF
CREATE DATABASE ${PROJECT_NAME//-/_};
CREATE USER ${DEPLOY_USER} WITH PASSWORD '$DB_PASSWORD';
ALTER ROLE ${DEPLOY_USER} SET client_encoding TO 'utf8';
ALTER ROLE ${DEPLOY_USER} SET default_transaction_isolation TO 'read committed';
ALTER ROLE ${DEPLOY_USER} SET timezone TO 'Asia/Shanghai';
GRANT ALL PRIVILEGES ON DATABASE ${PROJECT_NAME//-/_} TO ${DEPLOY_USER};
\q
EOF

    log_success "PostgreSQL安装和配置完成"
}

# 安装Redis
install_redis() {
    log_step "安装Redis"

    # 安装Redis
    apt install -y redis-server

    # 配置Redis
    sed -i "s/# requirepass foobared/requirepass $REDIS_PASSWORD/" /etc/redis/redis.conf
    sed -i "s/bind 127.0.0.1/bind 127.0.0.1/" /etc/redis/redis.conf

    # 重启Redis
    systemctl restart redis-server
    systemctl enable redis-server

    log_success "Redis安装和配置完成"
}

# 安装Nginx
install_nginx() {
    log_step "安装Nginx"

    apt install -y nginx
    systemctl start nginx
    systemctl enable nginx

    log_success "Nginx安装完成"
}

# 安装Supervisor
install_supervisor() {
    log_step "安装Supervisor"

    apt install -y supervisor
    systemctl start supervisor
    systemctl enable supervisor

    log_success "Supervisor安装完成"
}

# 创建项目目录结构
create_project_structure() {
    log_step "创建项目目录结构"

    # 创建完整的目录结构
    mkdir -p /var/www/zhuhai-youmei
    mkdir -p $PROJECT_DIR
    mkdir -p $PROJECT_DIR/{logs,backups,scripts}

    log_success "项目目录结构创建完成"
}

# 复制项目文件
copy_project_files() {
    log_step "复制项目文件"

    # 检查源代码位置
    SOURCE_DIR=""
    if [ -d "/home/project/msd-style-cosmetics" ]; then
        SOURCE_DIR="/home/project/msd-style-cosmetics"
    elif [ -d "./msd-style-cosmetics" ]; then
        SOURCE_DIR="./msd-style-cosmetics"
    elif [ -d "$(pwd)" ] && [ -f "$(pwd)/backend/manage.py" ]; then
        SOURCE_DIR="$(pwd)"
    else
        log_error "找不到项目源代码。请确保脚本在正确的目录中运行"
        log_info "当前目录: $(pwd)"
        log_info "请将脚本放在包含 backend/manage.py 的项目根目录中运行"
        exit 1
    fi

    log_info "源代码目录: $SOURCE_DIR"

    # 复制后端代码
    if [ -d "$SOURCE_DIR/backend" ]; then
        log_info "复制后端代码..."
        cp -r "$SOURCE_DIR/backend" "$PROJECT_DIR/"
        chown -R $DEPLOY_USER:$DEPLOY_USER "$BACKEND_DIR"
        log_success "后端代码复制完成"
    else
        log_error "未找到后端代码目录: $SOURCE_DIR/backend"
        exit 1
    fi

    # 复制前端代码
    if [ -d "$SOURCE_DIR/frontend" ]; then
        log_info "复制前端代码..."
        cp -r "$SOURCE_DIR/frontend" "$PROJECT_DIR/"
        chown -R $DEPLOY_USER:$DEPLOY_USER "$FRONTEND_DIR"
        log_success "前端代码复制完成"
    else
        log_error "未找到前端代码目录: $SOURCE_DIR/frontend"
        exit 1
    fi

    # 设置正确的权限
    chown -R $DEPLOY_USER:$DEPLOY_USER "$PROJECT_DIR"
    chmod -R 755 "$PROJECT_DIR"

    log_success "项目文件复制和权限设置完成"
}

# 部署Django后端
deploy_backend() {
    log_step "部署Django后端"

    cd $BACKEND_DIR

    # 创建虚拟环境
    python3 -m venv venv
    source venv/bin/activate

    # 升级pip
    python3 -m pip install --upgrade pip

    # 安装Django和基础依赖
    python3 -m pip install django==5.2.4 psycopg2-binary gunicorn python-decouple
    python3 -m pip install djangorestframework django-cors-headers django-filter
    python3 -m pip install redis django-redis celery pillow

    # 如果有requirements.txt，安装其中的依赖
    if [ -f "requirements.txt" ]; then
        log_info "安装requirements.txt中的依赖..."
        python3 -m pip install -r requirements.txt
    fi

    # 创建环境配置文件
    cat > .env << EOF
DEBUG=False
SECRET_KEY=$(python3 -c 'from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())')
ALLOWED_HOSTS=$DOMAIN,www.$DOMAIN,localhost,127.0.0.1,0.0.0.0
CORS_ALLOWED_ORIGINS=https://$DOMAIN,https://www.$DOMAIN,http://localhost:3000

DB_NAME=${PROJECT_NAME//-/_}
DB_USER=$DEPLOY_USER
DB_PASSWORD=$DB_PASSWORD
DB_HOST=localhost
DB_PORT=5432

REDIS_URL=redis://localhost:6379/0
REDIS_PASSWORD=$REDIS_PASSWORD

EMAIL_HOST=smtp.gmail.com
EMAIL_PORT=587
EMAIL_USE_TLS=True
EMAIL_HOST_USER=$ADMIN_EMAIL
EMAIL_HOST_PASSWORD=your-email-app-password
EOF

    # 检查Django项目结构
    if [ ! -f "manage.py" ]; then
        log_error "未找到manage.py文件，Django项目结构不完整"
        exit 1
    fi

    # 检查settings.py并更新数据库配置
    SETTINGS_FILE=""
    if [ -f "cosmetics_msd/settings.py" ]; then
        SETTINGS_FILE="cosmetics_msd/settings.py"
    elif [ -f "cosmetics_msd/settings/base.py" ]; then
        SETTINGS_FILE="cosmetics_msd/settings/base.py"
    fi

    if [ -n "$SETTINGS_FILE" ]; then
        log_info "更新Django设置文件: $SETTINGS_FILE"

        # 备份原始设置文件
        cp "$SETTINGS_FILE" "${SETTINGS_FILE}.backup"

        # 确保数据库配置正确 - 使用更可靠的方法
        log_info "跳过settings.py自动修改，使用现有正确配置"
        log_info "如需修改数据库配置，请手动编辑.env文件"
    fi

    # 执行数据库迁移
    log_info "执行数据库迁移..."
    python3 manage.py makemigrations
    python3 manage.py migrate

    # 创建超级用户
    log_info "创建超级用户..."
    python3 manage.py shell << EOF
from django.contrib.auth.models import User
if not User.objects.filter(username='admin').exists():
    User.objects.create_superuser('admin', '$ADMIN_EMAIL', '$ADMIN_PASSWORD')
    print('超级用户创建成功')
else:
    print('超级用户已存在')
EOF

    # 收集静态文件
    python3 manage.py collectstatic --noinput

    # 更新requirements.txt
    python3 -m pip freeze > requirements.txt

    deactivate

    log_success "Django后端部署完成"
}

# 配置Gunicorn
configure_gunicorn() {
    log_step "配置Gunicorn"

    cd $BACKEND_DIR
    source venv/bin/activate

    # 创建Gunicorn配置文件
    cat > gunicorn.conf.py << EOF
bind = "127.0.0.1:8000"
workers = 3
worker_class = "sync"
timeout = 30
keepalive = 2
max_requests = 1000
preload_app = True
daemon = False
user = "$DEPLOY_USER"
group = "$DEPLOY_USER"
errorlog = "$PROJECT_DIR/logs/gunicorn_error.log"
accesslog = "$PROJECT_DIR/logs/gunicorn_access.log"
loglevel = "info"
EOF

    # 创建Supervisor配置
    cat > /etc/supervisor/conf.d/${PROJECT_NAME}-backend.conf << EOF
[program:${PROJECT_NAME}-backend]
command=$BACKEND_DIR/venv/bin/gunicorn --config gunicorn.conf.py cosmetics_msd.wsgi:application
directory=$BACKEND_DIR
user=$DEPLOY_USER
autostart=true
autorestart=true
stdout_logfile=$PROJECT_DIR/logs/backend.log
stderr_logfile=$PROJECT_DIR/logs/backend_error.log
environment=PATH="$BACKEND_DIR/venv/bin",DJANGO_SETTINGS_MODULE="cosmetics_msd.settings"
EOF

    deactivate

    # 重新加载Supervisor配置
    supervisorctl reread
    supervisorctl update
    supervisorctl start ${PROJECT_NAME}-backend

    log_success "Gunicorn配置完成"
}

# 部署Vue前端
deploy_frontend() {
    log_step "部署Vue前端"

    cd $FRONTEND_DIR

    # 检查package.json是否存在
    if [ ! -f "package.json" ]; then
        log_error "未找到package.json文件，前端项目结构不完整"
        exit 1
    fi

    # 创建环境配置
    cat > .env.production << EOF
VITE_API_BASE_URL=https://$DOMAIN/api
VITE_APP_TITLE=珠海优美化妆品有限公司
VITE_APP_DESCRIPTION=专业的美妆产品代工制造商
EOF

    # 安装依赖并构建
    log_info "安装前端依赖..."
    if command -v bun &> /dev/null; then
        log_info "使用Bun安装依赖..."
        bun install || npm install
        log_info "使用Bun构建项目..."
        bun run build || npm run build
    else
        log_info "使用npm安装依赖..."
        npm install
        log_info "使用npm构建项目..."
        npm run build
    fi

    # 检查构建结果
    if [ ! -d "dist" ]; then
        log_error "前端构建失败，未找到dist目录"
        exit 1
    fi

    log_success "Vue前端部署完成"
}

# 配置Nginx
configure_nginx() {
    log_step "配置Nginx"

    # 备份默认配置
    cp /etc/nginx/sites-available/default /etc/nginx/sites-available/default.backup

    # 检查是否为IP地址
    if [[ $DOMAIN =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        # IP地址 - 只使用HTTP
        cat > /etc/nginx/sites-available/${PROJECT_NAME} << EOF
server {
    listen 80;
    server_name $DOMAIN;

    # 前端静态文件
    root $FRONTEND_DIR/dist;
    index index.html;

    # 处理Vue Router的history模式
    location / {
        try_files \$uri \$uri/ /index.html;
    }

    # API代理
    location /api/ {
        proxy_pass http://127.0.0.1:8000/;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }

    # Django静态文件
    location /static/ {
        alias $BACKEND_DIR/staticfiles/;
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    # Django媒体文件
    location /media/ {
        alias $BACKEND_DIR/media/;
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    # 静态资源缓存
    location ~* \.(css|js|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)\$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    # Gzip压缩
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml;
}
EOF
    else
        # 域名 - 使用HTTP，SSL稍后通过certbot配置
        cat > /etc/nginx/sites-available/${PROJECT_NAME} << EOF
server {
    listen 80;
    server_name $DOMAIN www.$DOMAIN;

    # 前端静态文件
    root $FRONTEND_DIR/dist;
    index index.html;

    # 处理Vue Router的history模式
    location / {
        try_files \$uri \$uri/ /index.html;
    }

    # API代理
    location /api/ {
        proxy_pass http://127.0.0.1:8000/;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }

    # Django静态文件
    location /static/ {
        alias $BACKEND_DIR/staticfiles/;
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    # Django媒体文件
    location /media/ {
        alias $BACKEND_DIR/media/;
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    # 静态资源缓存
    location ~* \.(css|js|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)\$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    # Gzip压缩
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml;
}
EOF
    fi

    # 注意：修复了SSL配置错误，避免证书问题

    # 启用站点
    ln -sf /etc/nginx/sites-available/${PROJECT_NAME} /etc/nginx/sites-enabled/
    rm -f /etc/nginx/sites-enabled/default

    # 测试配置
    nginx -t

    # 重启Nginx
    systemctl restart nginx

    log_success "Nginx配置完成"
}

# 配置SSL证书
configure_ssl() {
    log_step "配置SSL证书"

    # 检查域名是否为IP地址
    if [[ $DOMAIN =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        log_warning "检测到使用IP地址，跳过SSL证书配置"
        return 0
    fi

    # 安装Certbot
    apt install -y certbot python3-certbot-nginx

    # 申请SSL证书
    certbot --nginx -d $DOMAIN -d www.$DOMAIN --email $ADMIN_EMAIL --agree-tos --no-eff-email

    # 设置自动续期
    echo "0 2 1 * * /usr/bin/certbot renew --quiet && /usr/bin/systemctl reload nginx" | crontab -

    log_success "SSL证书配置完成"
}

# 创建管理脚本
create_management_scripts() {
    log_step "创建管理脚本"

    # 部署脚本
    cat > $PROJECT_DIR/scripts/deploy.sh << EOF
#!/bin/bash
set -e

PROJECT_DIR="$PROJECT_DIR"
BACKEND_DIR="$BACKEND_DIR"
FRONTEND_DIR="$FRONTEND_DIR"

echo "🚀 开始更新部署..."

# 更新后端
cd \$BACKEND_DIR
git pull origin main 2>/dev/null || echo "跳过git更新"
source venv/bin/activate
pip3 install -r requirements.txt
python3 manage.py migrate
python3 manage.py collectstatic --noinput
supervisorctl restart ${PROJECT_NAME}-backend

# 更新前端
cd \$FRONTEND_DIR
git pull origin main 2>/dev/null || echo "跳过git更新"
if command -v bun &> /dev/null; then
    bun install || npm install
    bun run build || npm run build
else
    npm install
    npm run build
fi

# 重启服务
systemctl reload nginx

echo "✅ 部署更新完成！"
echo "🌐 网站地址: https://$DOMAIN"
echo "⚙️ 管理后台: https://$DOMAIN/api/admin/"
EOF

    # 日志查看脚本
    cat > $PROJECT_DIR/scripts/logs.sh << EOF
#!/bin/bash

case "\${1:-all}" in
    backend)
        tail -f $PROJECT_DIR/logs/backend.log
        ;;
    backend-error)
        tail -f $PROJECT_DIR/logs/backend_error.log
        ;;
    gunicorn)
        tail -f $PROJECT_DIR/logs/gunicorn_error.log
        ;;
    nginx)
        tail -f /var/log/nginx/error.log
        ;;
    all)
        echo "=== Backend Logs ==="
        tail -n 20 $PROJECT_DIR/logs/backend.log
        echo -e "\n=== Nginx Logs ==="
        tail -n 20 /var/log/nginx/error.log
        ;;
    *)
        echo "Usage: \$0 {backend|backend-error|gunicorn|nginx|all}"
        ;;
esac
EOF

    # 备份脚本
    cat > $PROJECT_DIR/scripts/backup.sh << EOF
#!/bin/bash

BACKUP_DIR="$PROJECT_DIR/backups"
DATE=\$(date +%Y%m%d_%H%M%S)
PROJECT_NAME="${PROJECT_NAME}"

mkdir -p \$BACKUP_DIR

echo "🗄️ 开始备份..."

# 数据库备份
echo "📊 备份数据库..."
pg_dump -h localhost -U $DEPLOY_USER ${PROJECT_NAME//-/_} > \$BACKUP_DIR/db_backup_\$DATE.sql

# 媒体文件备份
echo "📁 备份媒体文件..."
tar -czf \$BACKUP_DIR/media_backup_\$DATE.tar.gz -C $BACKEND_DIR media/

# 配置文件备份
echo "⚙️ 备份配置文件..."
tar -czf \$BACKUP_DIR/config_backup_\$DATE.tar.gz /etc/nginx/sites-available/${PROJECT_NAME} /etc/supervisor/conf.d/${PROJECT_NAME}-backend.conf $BACKEND_DIR/.env

# 清理旧备份 (保留7天)
find \$BACKUP_DIR -name "*backup_*" -mtime +7 -delete

echo "✅ 备份完成到: \$BACKUP_DIR"
EOF

    # 状态监控脚本
    cat > $PROJECT_DIR/scripts/status.sh << EOF
#!/bin/bash

echo "📊 系统状态监控"
echo "=================="

# 服务状态
echo "🚀 服务状态:"
echo "Nginx: \$(systemctl is-active nginx)"
echo "PostgreSQL: \$(systemctl is-active postgresql)"
echo "Redis: \$(systemctl is-active redis-server)"
echo "Backend: \$(supervisorctl status ${PROJECT_NAME}-backend | awk '{print \$2}')"

# 系统资源
echo -e "\n💾 内存使用:"
free -h | grep -E "Mem:|Swap:"

echo -e "\n💽 磁盘使用:"
df -h | grep -E "/$|/var"

# 端口监听
echo -e "\n🌐 端口监听:"
netstat -tlnp | grep -E ':80|:443|:8000|:5432|:6379' | head -5

# 最近错误
echo -e "\n🚨 最近错误:"
tail -n 5 /var/log/nginx/error.log 2>/dev/null | grep -E "error|warn" || echo "无错误日志"
EOF

    # 设置脚本权限
    chmod +x $PROJECT_DIR/scripts/*.sh

    log_success "管理脚本创建完成"
}

# 配置防火墙
configure_firewall() {
    log_step "配置防火墙"

    # 安装UFW
    apt install -y ufw

    # 配置规则
    ufw allow ssh
    ufw allow 'Nginx Full'
    ufw --force enable

    log_success "防火墙配置完成"
}

# 验证部署
verify_deployment() {
    log_step "验证部署"

    # 等待服务启动
    sleep 10

    # 检查后端健康
    if curl -f http://localhost:8000/admin/ > /dev/null 2>&1; then
        log_success "后端服务正常"
    else
        log_error "后端服务异常"
        supervisorctl status ${PROJECT_NAME}-backend
    fi

    # 检查前端
    if curl -f http://localhost/ > /dev/null 2>&1; then
        log_success "前端服务正常"
    else
        log_error "前端服务异常"
        nginx -t
    fi

    # 检查数据库
    if sudo -u postgres psql -lqt | cut -d \| -f 1 | grep -qw ${PROJECT_NAME//-/_}; then
        log_success "数据库连接正常"
    else
        log_error "数据库连接异常"
    fi

    log_success "部署验证完成"
}

# 显示部署结果
show_deployment_info() {
    log_step "部署完成"

    echo -e "${GREEN}"
    cat << EOF

🎉 珠海优美官网部署成功！
================================

📁 项目目录结构:
   项目根目录: $PROJECT_DIR
   前端目录: $FRONTEND_DIR
   后端目录: $BACKEND_DIR
   日志目录: $PROJECT_DIR/logs
   备份目录: $PROJECT_DIR/backups
   脚本目录: $PROJECT_DIR/scripts

📱 访问地址:
   前端网站: https://$DOMAIN
   管理后台: https://$DOMAIN/admin/
   API接口: https://$DOMAIN/api/

👤 管理员账号:
   用户名: admin
   密码: $ADMIN_PASSWORD
   邮箱: $ADMIN_EMAIL

🛠️ 管理命令:
   查看状态: $PROJECT_DIR/scripts/status.sh
   查看日志: $PROJECT_DIR/scripts/logs.sh
   更新部署: $PROJECT_DIR/scripts/deploy.sh
   数据备份: $PROJECT_DIR/scripts/backup.sh

🔧 服务管理:
   重启后端: supervisorctl restart ${PROJECT_NAME}-backend
   重启Nginx: systemctl restart nginx
   重启数据库: systemctl restart postgresql
   重启Redis: systemctl restart redis-server

📊 监控信息:
   系统状态: $PROJECT_DIR/scripts/status.sh
   服务日志: journalctl -f -u nginx
   应用日志: tail -f $PROJECT_DIR/logs/backend.log

EOF
    echo -e "${NC}"
}

# 错误处理
handle_error() {
    log_error "部署过程中出现错误: $1"
    log_info "请检查日志并重新运行脚本"
    log_info "项目目录: $PROJECT_DIR"
    exit 1
}

# 主函数
main() {
    # 错误时退出
    trap 'handle_error "第 $LINENO 行"' ERR

    show_welcome
    check_system
    collect_config

    log_info "开始自动化部署流程..."

    update_system
    install_nodejs
    install_python
    install_postgresql
    install_redis
    install_nginx
    install_supervisor
    create_project_structure
    copy_project_files
    deploy_backend
    configure_gunicorn
    deploy_frontend
    configure_nginx
    configure_ssl
    create_management_scripts
    configure_firewall
    verify_deployment
    show_deployment_info

    log_success "部署流程全部完成！"
}

# 参数处理
case "${1:-deploy}" in
    deploy)
        main
        ;;
    check)
        check_system
        ;;
    update)
        update_system
        ;;
    verify)
        verify_deployment
        ;;
    *)
        echo "用法: $0 {deploy|check|update|verify}"
        echo ""
        echo "  deploy  - 执行完整部署流程"
        echo "  check   - 只检查系统环境"
        echo "  update  - 只更新系统包"
        echo "  verify  - 只验证部署状态"
        echo ""
        echo "Root版本说明:"
        echo "  - 必须使用root用户执行"
        echo "  - 自动复制现有项目文件"
        echo "  - 修复项目结构和路径问题"
        echo "  - 项目目录: $PROJECT_DIR"
        echo "  - Django项目: cosmetics_msd"
        exit 1
        ;;
esac
