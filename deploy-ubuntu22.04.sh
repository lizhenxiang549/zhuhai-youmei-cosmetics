#!/bin/bash

# Ubuntu 22.04 完整部署脚本
# 项目: 珠海优美化妆品项目
# 作者: Same Assistant
# 日期: $(date +"%Y-%m-%d")

set -e  # 遇到错误立即退出

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 项目配置
PROJECT_NAME="zhuhai-youmei"
PROJECT_ROOT="/var/www/zhuhai-youmei/ym-cosmetics"
FRONTEND_DIR="$PROJECT_ROOT/frontend"
BACKEND_DIR="$PROJECT_ROOT/backend"
NGINX_SITE_NAME="ym-cosmetics"
DOMAIN="youmei.local"  # 根据实际域名修改
DB_NAME="ym_cosmetics"
DB_USER="ym_user"
DB_PASSWORD="your_secure_password"  # 请修改为安全密码

# 日志函数
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}"
}

warn() {
    echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] WARNING: $1${NC}"
}

error() {
    echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ERROR: $1${NC}"
    exit 1
}

# 检查是否为root用户
check_root() {
    if [[ $EUID -ne 0 ]]; then
        error "此脚本需要root权限运行。请使用: sudo $0"
    fi
}

# 更新系统
update_system() {
    log "更新系统包..."
    apt update && apt upgrade -y
    log "系统更新完成"
}

# 安装基础依赖
install_basic_dependencies() {
    log "安装基础依赖..."
    apt install -y \
        curl \
        wget \
        git \
        unzip \
        software-properties-common \
        apt-transport-https \
        ca-certificates \
        gnupg \
        lsb-release \
        build-essential \
        supervisor \
        ufw
    log "基础依赖安装完成"
}

# 安装Node.js和npm
install_nodejs() {
    log "安装Node.js..."

    # 安装Node.js 18.x LTS
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
    apt install -y nodejs

    # 安装pnpm (更快的包管理器)
    npm install -g pnpm

    # 验证安装
    node_version=$(node --version)
    npm_version=$(npm --version)
    pnpm_version=$(pnpm --version)

    log "Node.js版本: $node_version"
    log "npm版本: $npm_version"
    log "pnpm版本: $pnpm_version"
}

# 安装Python3和相关依赖
install_python() {
    log "安装Python3和相关依赖..."

    # Ubuntu 22.04 默认已安装Python 3.10
    apt install -y \
        python3 \
        python3-pip \
        python3-venv \
        python3-dev \
        python3-setuptools \
        python3-wheel

    # 更新pip3
    python3 -m pip install --upgrade pip

    # 验证安装
    python_version=$(python3 --version)
    pip_version=$(python3 -m pip --version)

    log "Python版本: $python_version"
    log "pip版本: $pip_version"
}

# 安装PostgreSQL
install_postgresql() {
    log "安装PostgreSQL..."

    # 安装PostgreSQL和相关包
    apt install -y postgresql postgresql-contrib libpq-dev python3-dev

    # 启动PostgreSQL服务
    systemctl start postgresql
    systemctl enable postgresql

    # 创建数据库和用户
    sudo -u postgres psql << EOF
CREATE DATABASE $DB_NAME;
CREATE USER $DB_USER WITH PASSWORD '$DB_PASSWORD';
ALTER ROLE $DB_USER SET client_encoding TO 'utf8';
ALTER ROLE $DB_USER SET default_transaction_isolation TO 'read committed';
ALTER ROLE $DB_USER SET timezone TO 'Asia/Shanghai';
GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_USER;
\\q
EOF

    log "PostgreSQL安装和配置完成"
}

# 安装Redis
install_redis() {
    log "安装Redis..."

    apt install -y redis-server

    # 配置Redis
    sed -i 's/supervised no/supervised systemd/' /etc/redis/redis.conf

    # 启动Redis服务
    systemctl restart redis-server
    systemctl enable redis-server

    log "Redis安装和配置完成"
}

# 安装Nginx
install_nginx() {
    log "安装Nginx..."

    apt install -y nginx

    # 启动Nginx服务
    systemctl start nginx
    systemctl enable nginx

    log "Nginx安装完成"
}

# 创建项目目录
create_project_directories() {
    log "创建项目目录..."

    # 创建主项目目录
    mkdir -p "$PROJECT_ROOT"
    mkdir -p "$FRONTEND_DIR"
    mkdir -p "$BACKEND_DIR"

    # 创建日志目录
    mkdir -p "/var/log/$PROJECT_NAME"

    # 设置权限
    chown -R www-data:www-data "/var/www/$PROJECT_NAME"
    chmod -R 755 "/var/www/$PROJECT_NAME"

    log "项目目录创建完成"
}

# 配置后端Python环境
setup_backend() {
    log "配置后端Python环境..."

    cd "$BACKEND_DIR"

    # 创建Python虚拟环境
    python3 -m venv venv

    # 激活虚拟环境并安装依赖
    source venv/bin/activate

    # 如果存在requirements.txt则安装依赖
    if [[ -f "requirements.txt" ]]; then
        python3 -m pip install -r requirements.txt
        log "后端依赖安装完成"
    else
        warn "未找到requirements.txt文件，跳过依赖安装"
    fi

    # 创建Django环境配置文件
    cat > .env << EOF
DEBUG=False
SECRET_KEY=django-insecure-change-this-key-in-production-$(openssl rand -hex 32)
ALLOWED_HOSTS=localhost,127.0.0.1,0.0.0.0
DB_NAME=$DB_NAME
DB_USER=$DB_USER
DB_PASSWORD=$DB_PASSWORD
DB_HOST=localhost
DB_PORT=5432
USE_SQLITE=False
EOF

    deactivate
    log "后端环境配置完成"
}

# 配置前端环境
setup_frontend() {
    log "配置前端环境..."

    cd "$FRONTEND_DIR"

    # 如果存在package.json则安装依赖
    if [[ -f "package.json" ]]; then
        pnpm install
        log "前端依赖安装完成"

        # 构建前端项目
        if pnpm run build 2>/dev/null; then
            log "前端项目构建完成"
        else
            warn "前端构建失败或没有build脚本"
        fi
    else
        warn "未找到package.json文件，跳过前端依赖安装"
    fi
}

# 配置Nginx
configure_nginx() {
    log "配置Nginx..."

    # 创建Nginx配置文件
    cat > "/etc/nginx/sites-available/$NGINX_SITE_NAME" << EOF
server {
    listen 80;
    server_name $DOMAIN www.$DOMAIN;

    # 前端静态文件
    location / {
        root $FRONTEND_DIR/dist;
        try_files \$uri \$uri/ /index.html;

        # 缓存静态资源
        location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
            expires 1y;
            add_header Cache-Control "public, immutable";
        }
    }

    # API代理到后端
    location /api/ {
        proxy_pass http://127.0.0.1:5000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;

        # WebSocket支持
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
    }

    # 日志配置
    access_log /var/log/nginx/$NGINX_SITE_NAME.access.log;
    error_log /var/log/nginx/$NGINX_SITE_NAME.error.log;

    # 安全头
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Referrer-Policy "no-referrer-when-downgrade" always;
    add_header Content-Security-Policy "default-src 'self' http: https: data: blob: 'unsafe-inline'" always;
}
EOF

    # 启用站点
    ln -sf "/etc/nginx/sites-available/$NGINX_SITE_NAME" "/etc/nginx/sites-enabled/"

    # 删除默认站点
    rm -f /etc/nginx/sites-enabled/default

    # 测试Nginx配置
    if nginx -t; then
        systemctl reload nginx
        log "Nginx配置成功"
    else
        error "Nginx配置测试失败"
    fi
}

# 配置Supervisor (进程管理)
configure_supervisor() {
    log "配置Supervisor..."

    # 创建后端服务配置
    cat > "/etc/supervisor/conf.d/$PROJECT_NAME-backend.conf" << EOF
[program:$PROJECT_NAME-backend]
command=$BACKEND_DIR/venv/bin/gunicorn --bind 127.0.0.1:8000 --workers 3 cosmetics_msd.wsgi:application
directory=$BACKEND_DIR
user=www-data
autostart=true
autorestart=true
redirect_stderr=true
stdout_logfile=/var/log/$PROJECT_NAME/backend.log
stdout_logfile_maxbytes=50MB
stdout_logfile_backups=5
environment=DJANGO_SETTINGS_MODULE="cosmetics_msd.settings",DATABASE_URL="postgresql://$DB_USER:$DB_PASSWORD@localhost/$DB_NAME"
EOF

    # 重新加载Supervisor配置
    supervisorctl reread
    supervisorctl update

    log "Supervisor配置完成"
}

# 配置防火墙
configure_firewall() {
    log "配置防火墙..."

    # 启用UFW
    ufw --force enable

    # 允许SSH
    ufw allow ssh

    # 允许HTTP和HTTPS
    ufw allow 80/tcp
    ufw allow 443/tcp

    # 显示防火墙状态
    ufw status verbose

    log "防火墙配置完成"
}

# 创建SSL证书 (Let's Encrypt)
setup_ssl() {
    log "配置SSL证书..."

    # 安装Certbot
    apt install -y certbot python3-certbot-nginx

    # 获取SSL证书
    if [[ "$DOMAIN" != "youmei.local" ]]; then
        certbot --nginx -d "$DOMAIN" -d "www.$DOMAIN" --non-interactive --agree-tos --email "admin@$DOMAIN"
        log "SSL证书配置完成"
    else
        warn "使用默认域名，跳过SSL配置。请修改DOMAIN变量后重新运行"
    fi
}

# 创建备份脚本
create_backup_script() {
    log "创建备份脚本..."

    cat > "/usr/local/bin/backup-$PROJECT_NAME.sh" << 'EOF'
#!/bin/bash

# 备份脚本
BACKUP_DIR="/var/backups/ym-cosmetics"
DATE=$(date +"%Y%m%d_%H%M%S")

# 创建备份目录
mkdir -p "$BACKUP_DIR"

# 备份数据库
pg_dump -h localhost -U $DB_USER -d $DB_NAME > "$BACKUP_DIR/database_$DATE.sql"

# 备份项目文件
tar -czf "$BACKUP_DIR/project_$DATE.tar.gz" -C /var/www/zhuhai-youmei ym-cosmetics

# 保留最近30天的备份
find "$BACKUP_DIR" -name "*.sql" -mtime +30 -delete
find "$BACKUP_DIR" -name "*.tar.gz" -mtime +30 -delete

echo "备份完成: $DATE"
EOF

    chmod +x "/usr/local/bin/backup-$PROJECT_NAME.sh"

    # 添加到crontab (每天凌晨2点备份)
    (crontab -l 2>/dev/null; echo "0 2 * * * /usr/local/bin/backup-$PROJECT_NAME.sh") | crontab -

    log "备份脚本创建完成"
}

# 创建更新脚本
create_update_script() {
    log "创建更新脚本..."

    cat > "/usr/local/bin/update-$PROJECT_NAME.sh" << EOF
#!/bin/bash

# 更新脚本
PROJECT_ROOT="$PROJECT_ROOT"
FRONTEND_DIR="$FRONTEND_DIR"
BACKEND_DIR="$BACKEND_DIR"

log() {
    echo -e "\033[0;32m[$(date +'%Y-%m-%d %H:%M:%S')] \$1\033[0m"
}

log "开始更新项目..."

# 备份当前版本
/usr/local/bin/backup-$PROJECT_NAME.sh

# 更新代码 (如果使用Git)
if [[ -d "\$PROJECT_ROOT/.git" ]]; then
    cd "\$PROJECT_ROOT"
    git pull origin main
fi

# 更新后端依赖
cd "\$BACKEND_DIR"
source venv/bin/activate
python3 -m pip install -r requirements.txt
deactivate

# 更新前端依赖和构建
cd "\$FRONTEND_DIR"
pnpm install
pnpm run build

# 重启服务
supervisorctl restart $PROJECT_NAME-backend
systemctl reload nginx

log "项目更新完成"
EOF

    chmod +x "/usr/local/bin/update-$PROJECT_NAME.sh"

    log "更新脚本创建完成"
}

# 显示部署信息
show_deployment_info() {
    log "部署完成！"
    echo
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}           部署信息摘要               ${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo
    echo -e "${GREEN}项目根目录:${NC} $PROJECT_ROOT"
    echo -e "${GREEN}前端目录:${NC} $FRONTEND_DIR"
    echo -e "${GREEN}后端目录:${NC} $BACKEND_DIR"
    echo
    echo -e "${GREEN}网站地址:${NC} http://$DOMAIN"
    echo -e "${GREEN}数据库:${NC} $DB_NAME"
    echo -e "${GREEN}数据库用户:${NC} $DB_USER"
    echo
    echo -e "${GREEN}管理命令:${NC}"
    echo "  更新项目: /usr/local/bin/update-$PROJECT_NAME.sh"
    echo "  备份项目: /usr/local/bin/backup-$PROJECT_NAME.sh"
    echo "  查看日志: tail -f /var/log/$PROJECT_NAME/backend.log"
    echo "  重启后端: supervisorctl restart $PROJECT_NAME-backend"
    echo "  重载Nginx: systemctl reload nginx"
    echo
    echo -e "${YELLOW}重要提醒:${NC}"
    echo "1. 请修改数据库密码 (当前使用默认密码)"
    echo "2. 请修改域名配置 (当前为: $DOMAIN)"
    echo "3. 请配置DNS指向服务器IP"
    echo "4. 建议启用SSL证书"
    echo
}

# 主函数
main() {
    log "开始Ubuntu 22.04完整部署..."

    check_root
    update_system
    install_basic_dependencies
    install_nodejs
    install_python
    install_postgresql
    install_redis
    install_nginx
    create_project_directories
    setup_backend
    setup_frontend
    configure_nginx
    configure_supervisor
    configure_firewall
    create_backup_script
    create_update_script
    show_deployment_info

    log "部署完成！"
}

# 如果直接运行脚本，则执行主函数
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
