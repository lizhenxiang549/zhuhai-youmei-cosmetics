#!/bin/bash

# 快速修复常见问题脚本
# Ubuntu 22.04 - 珠海优美化妆品项目

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# 项目配置
PROJECT_ROOT="/var/www/zhuhai-youmei/ym-cosmetics"
FRONTEND_DIR="$PROJECT_ROOT/frontend"
BACKEND_DIR="$PROJECT_ROOT/backend"

log() {
    echo -e "${GREEN}[$(date +'%H:%M:%S')] $1${NC}"
}

warn() {
    echo -e "${YELLOW}[$(date +'%H:%M:%S')] $1${NC}"
}

error() {
    echo -e "${RED}[$(date +'%H:%M:%S')] $1${NC}"
}

info() {
    echo -e "${BLUE}[$(date +'%H:%M:%S')] $1${NC}"
}

# 显示菜单
show_menu() {
    clear
    echo -e "${BLUE}===============================================${NC}"
    echo -e "${BLUE}      珠海优美化妆品项目 - 快速修复工具      ${NC}"
    echo -e "${BLUE}===============================================${NC}"
    echo
    echo "请选择要执行的修复操作："
    echo
    echo "  1. 修复Python命令问题 (python -> python3)"
    echo "  2. 重启所有服务"
    echo "  3. 修复文件权限"
    echo "  4. 重建Python虚拟环境"
    echo "  5. 重新安装前端依赖"
    echo "  6. 修复Nginx配置"
    echo "  7. 修复数据库连接"
    echo "  8. 清理系统缓存"
    echo "  9. 完整健康检查"
    echo " 10. 查看系统状态"
    echo " 11. 查看日志"
    echo "  0. 退出"
    echo
    echo -n "请输入选项 [0-11]: "
}

# 1. 修复Python命令问题
fix_python_commands() {
    log "修复Python命令问题..."

    if [[ -f "fix-python-commands.sh" ]]; then
        bash fix-python-commands.sh
    else
        warn "fix-python-commands.sh 脚本不存在，手动修复..."

        # 创建python到python3的软链接
        if ! command -v python &> /dev/null; then
            ln -sf /usr/bin/python3 /usr/bin/python
            log "已创建python到python3的软链接"
        fi

        # 修复虚拟环境
        if [[ -d "$BACKEND_DIR/venv" ]]; then
            cd "$BACKEND_DIR"
            source venv/bin/activate
            python3 -m pip install --upgrade pip
            deactivate
        fi
    fi

    log "Python命令修复完成"
}

# 2. 重启所有服务
restart_all_services() {
    log "重启所有服务..."

    systemctl restart nginx
    log "Nginx 已重启"

    systemctl restart postgresql
    log "PostgreSQL 已重启"

    systemctl restart redis-server
    log "Redis 已重启"

    systemctl restart supervisor
    log "Supervisor 已重启"

    # 等待服务启动
    sleep 5

    # 重启后端应用
    if supervisorctl status zhuhai-youmei-backend &>/dev/null; then
        supervisorctl restart zhuhai-youmei-backend
        log "后端应用已重启"
    else
        warn "后端应用配置不存在"
    fi

    log "所有服务重启完成"
}

# 3. 修复文件权限
fix_file_permissions() {
    log "修复文件权限..."

    if [[ -d "$PROJECT_ROOT" ]]; then
        chown -R www-data:www-data "$PROJECT_ROOT"
        chmod -R 755 "$PROJECT_ROOT"
        log "项目目录权限已修复"
    fi

    # 创建并修复日志目录权限
    mkdir -p /var/log/zhuhai-youmei
    chown -R www-data:www-data /var/log/zhuhai-youmei
    chmod -R 755 /var/log/zhuhai-youmei
    log "日志目录权限已修复"

    # 修复Nginx配置权限
    if [[ -f "/etc/nginx/sites-available/ym-cosmetics" ]]; then
        chmod 644 /etc/nginx/sites-available/ym-cosmetics
        log "Nginx配置权限已修复"
    fi

    log "文件权限修复完成"
}

# 4. 重建Python虚拟环境
rebuild_virtual_environment() {
    log "重建Python虚拟环境..."

    if [[ ! -d "$BACKEND_DIR" ]]; then
        error "后端目录不存在: $BACKEND_DIR"
        return 1
    fi

    cd "$BACKEND_DIR"

    # 备份requirements.txt
    if [[ -f "requirements.txt" ]]; then
        cp requirements.txt requirements.txt.backup
        log "已备份requirements.txt"
    fi

    # 删除旧的虚拟环境
    if [[ -d "venv" ]]; then
        rm -rf venv
        log "已删除旧的虚拟环境"
    fi

    # 创建新的虚拟环境
    python3 -m venv venv
    source venv/bin/activate

    # 升级pip
    python3 -m pip install --upgrade pip
    log "pip已升级"

    # 安装常用依赖
    python3 -m pip install flask gunicorn psycopg2-binary redis

    # 安装项目依赖
    if [[ -f "requirements.txt" ]]; then
        python3 -m pip install -r requirements.txt
        log "项目依赖已安装"
    fi

    deactivate
    log "Python虚拟环境重建完成"
}

# 5. 重新安装前端依赖
reinstall_frontend_dependencies() {
    log "重新安装前端依赖..."

    if [[ ! -d "$FRONTEND_DIR" ]]; then
        error "前端目录不存在: $FRONTEND_DIR"
        return 1
    fi

    cd "$FRONTEND_DIR"

    # 清理旧的依赖
    if [[ -d "node_modules" ]]; then
        rm -rf node_modules
        log "已清理旧的node_modules"
    fi

    if [[ -f "package-lock.json" ]]; then
        rm -f package-lock.json
        log "已清理package-lock.json"
    fi

    # 安装依赖
    if command -v pnpm &> /dev/null; then
        pnpm install
        log "使用pnpm安装依赖完成"

        # 构建项目
        if pnpm run build 2>/dev/null; then
            log "前端项目构建完成"
        else
            warn "前端构建失败或没有build脚本"
        fi
    else
        npm install
        log "使用npm安装依赖完成"

        # 构建项目
        if npm run build 2>/dev/null; then
            log "前端项目构建完成"
        else
            warn "前端构建失败或没有build脚本"
        fi
    fi

    log "前端依赖重新安装完成"
}

# 6. 修复Nginx配置
fix_nginx_config() {
    log "修复Nginx配置..."

    # 测试当前配置
    if nginx -t &>/dev/null; then
        log "当前Nginx配置正常"
    else
        warn "Nginx配置有问题，尝试修复..."

        # 备份当前配置
        if [[ -f "/etc/nginx/sites-available/ym-cosmetics" ]]; then
            cp /etc/nginx/sites-available/ym-cosmetics /etc/nginx/sites-available/ym-cosmetics.backup
            log "已备份当前配置"
        fi

        # 创建基本配置
        cat > /etc/nginx/sites-available/ym-cosmetics << EOF
server {
    listen 80;
    server_name localhost;

    location / {
        root $FRONTEND_DIR/dist;
        try_files \$uri \$uri/ /index.html;
    }

    location /api/ {
        proxy_pass http://127.0.0.1:5000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    }
}
EOF

        log "已创建基本Nginx配置"
    fi

    # 启用站点
    ln -sf /etc/nginx/sites-available/ym-cosmetics /etc/nginx/sites-enabled/

    # 禁用默认站点
    if [[ -L "/etc/nginx/sites-enabled/default" ]]; then
        rm -f /etc/nginx/sites-enabled/default
    fi

    # 重新测试配置
    if nginx -t; then
        systemctl reload nginx
        log "Nginx配置修复完成"
    else
        error "Nginx配置修复失败"
    fi
}

# 7. 修复数据库连接
fix_database_connection() {
    log "修复数据库连接..."

    # 重启PostgreSQL
    systemctl restart postgresql
    log "PostgreSQL已重启"

    # 等待PostgreSQL启动
    sleep 10

    # 测试连接
    if sudo -u postgres psql -c "SELECT 1;" &>/dev/null; then
        log "PostgreSQL连接正常"

        # 检查项目数据库
        if ! sudo -u postgres psql -d zhuhai_youmei -c "SELECT 1;" &>/dev/null; then
            log "创建项目数据库..."
            sudo -u postgres psql << EOF
CREATE DATABASE zhuhai_youmei;
CREATE USER youmei_user WITH PASSWORD 'youmei_password';
ALTER ROLE youmei_user SET client_encoding TO 'utf8';
ALTER ROLE youmei_user SET default_transaction_isolation TO 'read committed';
ALTER ROLE youmei_user SET timezone TO 'Asia/Shanghai';
GRANT ALL PRIVILEGES ON DATABASE zhuhai_youmei TO youmei_user;
\\q
EOF
            log "数据库和用户已创建"
        fi
    else
        error "PostgreSQL连接失败"

        # 尝试重置PostgreSQL
        warn "尝试重启PostgreSQL服务..."
        systemctl stop postgresql
        sleep 5
        systemctl start postgresql
        sleep 10
    fi

    # 检查Redis
    if redis-cli ping &>/dev/null; then
        log "Redis连接正常"
    else
        warn "Redis连接失败，重启Redis..."
        systemctl restart redis-server
    fi

    log "数据库连接修复完成"
}

# 8. 清理系统缓存
clean_system_cache() {
    log "清理系统缓存..."

    # 清理APT缓存
    apt autoremove -y
    apt autoclean
    log "APT缓存已清理"

    # 清理系统日志
    journalctl --vacuum-time=7d
    log "系统日志已清理"

    # 清理临时文件
    find /tmp -type f -atime +7 -delete 2>/dev/null || true
    log "临时文件已清理"

    # 清理npm缓存
    if command -v npm &> /dev/null; then
        npm cache clean --force 2>/dev/null || true
        log "npm缓存已清理"
    fi

    # 清理pip缓存
    if command -v pip3 &> /dev/null; then
        pip3 cache purge 2>/dev/null || true
        log "pip缓存已清理"
    fi

    log "系统缓存清理完成"
}

# 9. 完整健康检查
full_health_check() {
    log "执行完整健康检查..."

    if [[ -f "deployment-check.sh" ]]; then
        bash deployment-check.sh
    else
        warn "deployment-check.sh 脚本不存在，执行简单检查..."

        # 检查服务状态
        services=("nginx" "postgresql" "redis-server" "supervisor")
        for service in "${services[@]}"; do
            if systemctl is-active --quiet "$service"; then
                log "$service 服务正常"
            else
                error "$service 服务异常"
            fi
        done

        # 检查端口
        ports=("80" "3306" "6379")
        for port in "${ports[@]}"; do
            if netstat -tlnp | grep -q ":$port "; then
                log "端口 $port 正常"
            else
                warn "端口 $port 未监听"
            fi
        done
    fi

    log "健康检查完成"
}

# 10. 查看系统状态
show_system_status() {
    info "系统状态信息："
    echo

    echo -e "${BLUE}服务状态:${NC}"
    systemctl status nginx --no-pager -l
    echo
    systemctl status postgresql --no-pager -l
    echo
    systemctl status redis-server --no-pager -l
    echo
    systemctl status supervisor --no-pager -l
    echo

    echo -e "${BLUE}进程状态:${NC}"
    supervisorctl status
    echo

    echo -e "${BLUE}端口监听:${NC}"
    netstat -tlnp | grep -E ":(80|443|3306|6379|5000) "
    echo

    echo -e "${BLUE}系统资源:${NC}"
    free -h
    echo
    df -h
    echo

    echo -e "${BLUE}最近启动时间:${NC}"
    uptime
}

# 11. 查看日志
show_logs() {
    info "选择要查看的日志："
    echo
    echo "1. Nginx访问日志"
    echo "2. Nginx错误日志"
    echo "3. 后端应用日志"
    echo "4. PostgreSQL错误日志"
    echo "5. Redis日志"
    echo "6. 系统日志"
    echo "0. 返回主菜单"
    echo
    read -p "请选择 [0-6]: " log_choice

    case $log_choice in
        1)
            tail -f /var/log/nginx/ym-cosmetics.access.log 2>/dev/null || tail -f /var/log/nginx/access.log
            ;;
        2)
            tail -f /var/log/nginx/ym-cosmetics.error.log 2>/dev/null || tail -f /var/log/nginx/error.log
            ;;
        3)
            tail -f /var/log/zhuhai-youmei/backend.log 2>/dev/null || echo "后端日志文件不存在"
            ;;
        4)
            tail -f /var/log/postgresql/postgresql-15-main.log
            ;;
        5)
            tail -f /var/log/redis/redis-server.log
            ;;
        6)
            journalctl -f
            ;;
        0)
            return
            ;;
        *)
            warn "无效选择"
            ;;
    esac
}

# 检查是否为root用户
check_root() {
    if [[ $EUID -ne 0 ]]; then
        error "此脚本需要root权限运行。请使用: sudo $0"
        exit 1
    fi
}

# 主循环
main() {
    check_root

    while true; do
        show_menu
        read -r choice

        case $choice in
            1)
                fix_python_commands
                ;;
            2)
                restart_all_services
                ;;
            3)
                fix_file_permissions
                ;;
            4)
                rebuild_virtual_environment
                ;;
            5)
                reinstall_frontend_dependencies
                ;;
            6)
                fix_nginx_config
                ;;
            7)
                fix_database_connection
                ;;
            8)
                clean_system_cache
                ;;
            9)
                full_health_check
                ;;
            10)
                show_system_status
                ;;
            11)
                show_logs
                ;;
            0)
                log "退出程序"
                exit 0
                ;;
            *)
                warn "无效选择，请重新输入"
                ;;
        esac

        echo
        read -p "按回车键继续..."
    done
}

# 如果直接运行脚本，则执行主函数
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
