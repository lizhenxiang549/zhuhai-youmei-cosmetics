#!/bin/bash

# 快速修复Supervisor配置问题
# 针对PostgreSQL数据库和Django项目

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# 项目配置
PROJECT_ROOT="/var/www/zhuhai-youmei/ym-cosmetics"
BACKEND_DIR="$PROJECT_ROOT/backend"
DB_NAME="zhuhai_youmei"
DB_USER="youmei_user"
DB_PASSWORD="youmei123"

log() {
    echo -e "${GREEN}[$(date +'%H:%M:%S')] $1${NC}"
}

warn() {
    echo -e "${YELLOW}[$(date +'%H:%M:%S')] $1${NC}"
}

error() {
    echo -e "${RED}[$(date +'%H:%M:%S')] $1${NC}"
    exit 1
}

# 检查是否为root用户
check_root() {
    if [[ $EUID -ne 0 ]]; then
        error "此脚本需要root权限运行。请使用: sudo $0"
    fi
}

# 修复Supervisor配置
fix_supervisor_config() {
    log "修复Supervisor配置..."

    # 备份原配置文件
    local config_file="/etc/supervisor/conf.d/zhuhai-youmei-backend.conf"
    if [[ -f "$config_file" ]]; then
        cp "$config_file" "$config_file.backup"
        log "已备份原配置文件"
    fi

    # 创建正确的Supervisor配置
    cat > "$config_file" << 'EOF'
[program:zhuhai-youmei-backend]
command=/var/www/zhuhai-youmei/ym-cosmetics/backend/venv/bin/gunicorn --bind 127.0.0.1:8000 --workers 3 cosmetics_msd.wsgi:application
directory=/var/www/zhuhai-youmei/ym-cosmetics/backend
user=www-data
autostart=true
autorestart=true
redirect_stderr=true
stdout_logfile=/var/log/zhuhai-youmei/backend.log
stdout_logfile_maxbytes=50MB
stdout_logfile_backups=5
environment=DJANGO_SETTINGS_MODULE="cosmetics_msd.settings"
EOF

    log "Supervisor配置已更新"
}

# 确保gunicorn已安装
ensure_gunicorn_installed() {
    log "检查gunicorn安装..."

    if [[ -d "$BACKEND_DIR/venv" ]]; then
        cd "$BACKEND_DIR"
        source venv/bin/activate

        # 检查gunicorn是否已安装
        if ! python -c "import gunicorn" &>/dev/null; then
            log "安装gunicorn..."
            pip install gunicorn
        else
            log "gunicorn已安装"
        fi

        deactivate
    else
        warn "虚拟环境不存在，请先运行完整部署脚本"
    fi
}

# 创建日志目录
create_log_directory() {
    log "创建日志目录..."

    mkdir -p /var/log/zhuhai-youmei
    chown -R www-data:www-data /var/log/zhuhai-youmei
    chmod -R 755 /var/log/zhuhai-youmei

    log "日志目录已创建"
}

# 重新加载Supervisor配置
reload_supervisor() {
    log "重新加载Supervisor配置..."

    # 重新读取配置
    supervisorctl reread
    supervisorctl update

    # 检查配置是否成功
    if supervisorctl status zhuhai-youmei-backend &>/dev/null; then
        log "Supervisor配置已成功加载"

        # 启动或重启服务
        supervisorctl restart zhuhai-youmei-backend
        log "后端服务已重启"
    else
        error "Supervisor配置加载失败"
    fi
}

# 测试服务状态
test_service() {
    log "测试服务状态..."

    # 等待服务启动
    sleep 5

    # 检查进程状态
    local status=$(supervisorctl status zhuhai-youmei-backend)
    if echo "$status" | grep -q "RUNNING"; then
        log "后端服务运行正常: $status"
    else
        warn "后端服务可能有问题: $status"

        # 查看日志
        if [[ -f "/var/log/zhuhai-youmei/backend.log" ]]; then
            echo "最近的日志:"
            tail -n 20 /var/log/zhuhai-youmei/backend.log
        fi
    fi

    # 检查端口监听
    if netstat -tlnp | grep -q ":8000 "; then
        log "端口8000正在监听"
    else
        warn "端口8000未在监听"
    fi
}

# 修复Nginx配置
fix_nginx_config() {
    log "检查Nginx配置..."

    local nginx_config="/etc/nginx/sites-available/ym-cosmetics"
    if [[ -f "$nginx_config" ]]; then
        # 检查API代理端口
        if grep -q "proxy_pass.*:5000" "$nginx_config"; then
            log "修复Nginx API代理端口..."
            sed -i 's|proxy_pass http://127.0.0.1:5000|proxy_pass http://127.0.0.1:8000|g' "$nginx_config"

            # 重新加载Nginx
            nginx -t && systemctl reload nginx
            log "Nginx配置已更新"
        else
            log "Nginx配置无需修改"
        fi
    else
        warn "Nginx配置文件不存在"
    fi
}

# 显示状态信息
show_status() {
    log "显示服务状态..."

    echo
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}           服务状态摘要               ${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo

    echo -e "${GREEN}Supervisor状态:${NC}"
    supervisorctl status zhuhai-youmei-backend || true
    echo

    echo -e "${GREEN}端口监听:${NC}"
    netstat -tlnp | grep -E ":(80|8000) " || true
    echo

    echo -e "${GREEN}日志位置:${NC}"
    echo "  后端日志: /var/log/zhuhai-youmei/backend.log"
    echo "  Nginx日志: /var/log/nginx/ym-cosmetics.error.log"
    echo

    echo -e "${GREEN}有用命令:${NC}"
    echo "  查看后端日志: sudo tail -f /var/log/zhuhai-youmei/backend.log"
    echo "  重启后端: sudo supervisorctl restart zhuhai-youmei-backend"
    echo "  查看状态: sudo supervisorctl status"
    echo "  重新加载配置: sudo supervisorctl reread && sudo supervisorctl update"
}

# 主函数
main() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}     修复Supervisor配置问题           ${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo

    check_root
    fix_supervisor_config
    ensure_gunicorn_installed
    create_log_directory
    reload_supervisor
    fix_nginx_config
    test_service
    show_status

    echo
    echo -e "${GREEN}修复完成！${NC}"
    echo -e "${YELLOW}如果服务仍有问题，请查看日志文件排查具体原因。${NC}"
}

# 如果直接运行脚本，则执行主函数
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
