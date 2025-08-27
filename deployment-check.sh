#!/bin/bash

# 部署状态检查和诊断脚本
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

# 状态标志
ISSUES_FOUND=0

log() {
    echo -e "${GREEN}[✓] $1${NC}"
}

warn() {
    echo -e "${YELLOW}[!] $1${NC}"
    ((ISSUES_FOUND++))
}

error() {
    echo -e "${RED}[✗] $1${NC}"
    ((ISSUES_FOUND++))
}

info() {
    echo -e "${BLUE}[i] $1${NC}"
}

# 检查系统服务状态
check_system_services() {
    info "检查系统服务状态..."

    # 检查Nginx
    if systemctl is-active --quiet nginx; then
        log "Nginx 服务正在运行"
    else
        error "Nginx 服务未运行"
    fi

    # 检查PostgreSQL
    if systemctl is-active --quiet postgresql; then
        log "PostgreSQL 服务正在运行"
    else
        error "PostgreSQL 服务未运行"
    fi

    # 检查Redis
    if systemctl is-active --quiet redis-server; then
        log "Redis 服务正在运行"
    else
        error "Redis 服务未运行"
    fi

    # 检查Supervisor
    if systemctl is-active --quiet supervisor; then
        log "Supervisor 服务正在运行"
    else
        error "Supervisor 服务未运行"
    fi
}

# 检查项目目录结构
check_project_structure() {
    info "检查项目目录结构..."

    if [[ -d "$PROJECT_ROOT" ]]; then
        log "项目根目录存在: $PROJECT_ROOT"
    else
        error "项目根目录不存在: $PROJECT_ROOT"
        return
    fi

    if [[ -d "$FRONTEND_DIR" ]]; then
        log "前端目录存在: $FRONTEND_DIR"
    else
        error "前端目录不存在: $FRONTEND_DIR"
    fi

    if [[ -d "$BACKEND_DIR" ]]; then
        log "后端目录存在: $BACKEND_DIR"
    else
        error "后端目录不存在: $BACKEND_DIR"
    fi
}

# 检查Python环境
check_python_environment() {
    info "检查Python环境..."

    # 检查Python3
    if command -v python3 &> /dev/null; then
        python_version=$(python3 --version)
        log "Python3 已安装: $python_version"
    else
        error "Python3 未安装"
    fi

    # 检查pip3
    if command -v pip3 &> /dev/null; then
        pip_version=$(pip3 --version)
        log "pip3 已安装: $pip_version"
    else
        error "pip3 未安装"
    fi

    # 检查虚拟环境
    if [[ -d "$BACKEND_DIR/venv" ]]; then
        log "Python虚拟环境存在"

        # 检查虚拟环境中的Python版本
        if [[ -f "$BACKEND_DIR/venv/bin/python3" ]]; then
            venv_python=$("$BACKEND_DIR/venv/bin/python3" --version)
            log "虚拟环境Python版本: $venv_python"
        else
            error "虚拟环境中的Python3不存在"
        fi
    else
        error "Python虚拟环境不存在"
    fi

    # 检查requirements.txt
    if [[ -f "$BACKEND_DIR/requirements.txt" ]]; then
        log "requirements.txt 文件存在"
    else
        warn "requirements.txt 文件不存在"
    fi
}

# 检查Node.js环境
check_nodejs_environment() {
    info "检查Node.js环境..."

    if command -v node &> /dev/null; then
        node_version=$(node --version)
        log "Node.js 已安装: $node_version"
    else
        error "Node.js 未安装"
    fi

    if command -v npm &> /dev/null; then
        npm_version=$(npm --version)
        log "npm 已安装: $npm_version"
    else
        error "npm 未安装"
    fi

    # 检查pnpm
    if command -v pnpm &> /dev/null; then
        pnpm_version=$(pnpm --version)
        log "pnpm 已安装: $pnpm_version"
    else
        warn "pnpm 未安装，建议安装以提高性能"
    fi

    # 检查package.json
    if [[ -f "$FRONTEND_DIR/package.json" ]]; then
        log "package.json 文件存在"
    else
        warn "package.json 文件不存在"
    fi

    # 检查node_modules
    if [[ -d "$FRONTEND_DIR/node_modules" ]]; then
        log "node_modules 目录存在"
    else
        warn "node_modules 目录不存在，需要运行 npm install"
    fi
}

# 检查数据库连接
check_database() {
    info "检查数据库..."

    # 检查PostgreSQL连接
    if sudo -u postgres psql -c "SELECT 1;" &>/dev/null; then
        log "PostgreSQL 连接正常"

        # 检查项目数据库
        if sudo -u postgres psql -d zhuhai_youmei -c "SELECT 1;" &>/dev/null; then
            log "项目数据库 zhuhai_youmei 存在"
        else
            warn "项目数据库 zhuhai_youmei 不存在"
        fi
    else
        error "无法连接到PostgreSQL数据库"
    fi

    # 检查Redis连接
    if redis-cli ping &>/dev/null; then
        log "Redis 连接正常"
    else
        error "无法连接到Redis"
    fi
}

# 检查Nginx配置
check_nginx_config() {
    info "检查Nginx配置..."

    # 测试Nginx配置
    if nginx -t &>/dev/null; then
        log "Nginx 配置语法正确"
    else
        error "Nginx 配置语法错误"
        nginx -t
    fi

    # 检查站点配置
    local site_config="/etc/nginx/sites-available/ym-cosmetics"
    if [[ -f "$site_config" ]]; then
        log "站点配置文件存在"

        # 检查是否启用
        if [[ -L "/etc/nginx/sites-enabled/ym-cosmetics" ]]; then
            log "站点配置已启用"
        else
            warn "站点配置未启用"
        fi
    else
        error "站点配置文件不存在"
    fi
}

# 检查Supervisor配置
check_supervisor_config() {
    info "检查Supervisor配置..."

    local supervisor_config="/etc/supervisor/conf.d/zhuhai-youmei-backend.conf"
    if [[ -f "$supervisor_config" ]]; then
        log "Supervisor配置文件存在"

        # 检查进程状态
        if supervisorctl status zhuhai-youmei-backend &>/dev/null; then
            status=$(supervisorctl status zhuhai-youmei-backend)
            if echo "$status" | grep -q "RUNNING"; then
                log "后端进程正在运行"
            else
                error "后端进程未运行: $status"
            fi
        else
            error "后端进程配置不存在"
        fi
    else
        error "Supervisor配置文件不存在"
    fi
}

# 检查防火墙配置
check_firewall() {
    info "检查防火墙配置..."

    if command -v ufw &> /dev/null; then
        if ufw status | grep -q "Status: active"; then
            log "UFW 防火墙已启用"

            # 检查HTTP/HTTPS端口
            if ufw status | grep -q "80/tcp"; then
                log "HTTP端口 (80) 已开放"
            else
                warn "HTTP端口 (80) 未开放"
            fi

            if ufw status | grep -q "443/tcp"; then
                log "HTTPS端口 (443) 已开放"
            else
                warn "HTTPS端口 (443) 未开放"
            fi
        else
            warn "UFW 防火墙未启用"
        fi
    else
        warn "UFW 防火墙未安装"
    fi
}

# 检查文件权限
check_file_permissions() {
    info "检查文件权限..."

    # 检查项目目录权限
    if [[ -d "$PROJECT_ROOT" ]]; then
        owner=$(stat -c '%U:%G' "$PROJECT_ROOT")
        if [[ "$owner" == "www-data:www-data" ]]; then
            log "项目目录权限正确"
        else
            warn "项目目录权限不正确，当前: $owner，应为: www-data:www-data"
        fi
    fi

    # 检查日志目录
    local log_dir="/var/log/zhuhai-youmei"
    if [[ -d "$log_dir" ]]; then
        log "日志目录存在"
    else
        warn "日志目录不存在: $log_dir"
    fi
}

# 检查端口占用
check_ports() {
    info "检查端口占用..."

    # 检查80端口
    if netstat -tlnp | grep -q ":80 "; then
        log "端口 80 已被占用 (正常)"
    else
        warn "端口 80 未被占用"
    fi

    # 检查443端口
    if netstat -tlnp | grep -q ":443 "; then
        log "端口 443 已被占用 (正常)"
    else
        warn "端口 443 未被占用 (可能未配置SSL)"
    fi

    # 检查5000端口（Flask默认端口）
    if netstat -tlnp | grep -q ":5000 "; then
        log "端口 5000 已被占用 (后端服务正在运行)"
    else
        warn "端口 5000 未被占用 (后端服务可能未运行)"
    fi
}

# 检查日志文件
check_logs() {
    info "检查日志文件..."

    # 检查Nginx日志
    local nginx_access_log="/var/log/nginx/ym-cosmetics.access.log"
    local nginx_error_log="/var/log/nginx/ym-cosmetics.error.log"

    if [[ -f "$nginx_access_log" ]]; then
        log "Nginx访问日志存在"
    else
        warn "Nginx访问日志不存在"
    fi

    if [[ -f "$nginx_error_log" ]]; then
        log "Nginx错误日志存在"

        # 检查最近的错误
        if [[ -s "$nginx_error_log" ]]; then
            recent_errors=$(tail -n 10 "$nginx_error_log" | wc -l)
            if [[ $recent_errors -gt 0 ]]; then
                warn "发现 $recent_errors 个最近的Nginx错误"
            fi
        fi
    else
        warn "Nginx错误日志不存在"
    fi

    # 检查后端日志
    local backend_log="/var/log/zhuhai-youmei/backend.log"
    if [[ -f "$backend_log" ]]; then
        log "后端日志存在"
    else
        warn "后端日志不存在"
    fi
}

# 生成诊断报告
generate_diagnostic_report() {
    info "生成诊断报告..."

    local report_file="/tmp/deployment_diagnostic_$(date +%Y%m%d_%H%M%S).txt"

    cat > "$report_file" << EOF
珠海优美化妆品项目 - 部署诊断报告
=====================================
日期: $(date)
服务器: $(hostname)
操作系统: $(lsb_release -d | cut -f2)

系统服务状态:
------------
Nginx: $(systemctl is-active nginx 2>/dev/null || echo "未安装")
PostgreSQL: $(systemctl is-active postgresql 2>/dev/null || echo "未安装")
Redis: $(systemctl is-active redis-server 2>/dev/null || echo "未安装")
Supervisor: $(systemctl is-active supervisor 2>/dev/null || echo "未安装")

Python环境:
----------
Python3: $(python3 --version 2>/dev/null || echo "未安装")
pip3: $(pip3 --version 2>/dev/null || echo "未安装")
虚拟环境: $([[ -d "$BACKEND_DIR/venv" ]] && echo "存在" || echo "不存在")

Node.js环境:
-----------
Node.js: $(node --version 2>/dev/null || echo "未安装")
npm: $(npm --version 2>/dev/null || echo "未安装")
pnpm: $(pnpm --version 2>/dev/null || echo "未安装")

端口占用:
--------
EOF

    netstat -tlnp | grep -E ":(80|443|3306|6379|5000) " >> "$report_file" 2>/dev/null || echo "无相关端口占用" >> "$report_file"

    echo >> "$report_file"
    echo "磁盘空间:" >> "$report_file"
    df -h >> "$report_file"

    echo >> "$report_file"
    echo "内存使用:" >> "$report_file"
    free -h >> "$report_file"

    log "诊断报告已生成: $report_file"
}

# 提供修复建议
provide_fix_suggestions() {
    info "修复建议..."

    if [[ $ISSUES_FOUND -eq 0 ]]; then
        log "恭喜！未发现任何问题，部署状态良好。"
        return
    fi

    echo
    echo -e "${YELLOW}发现 $ISSUES_FOUND 个问题，建议修复步骤:${NC}"
    echo

    # 检查是否需要运行完整部署脚本
    if ! command -v python3 &> /dev/null || ! command -v node &> /dev/null; then
        echo "1. 运行完整部署脚本："
        echo "   sudo bash deploy-ubuntu22.04.sh"
        echo
    fi

    # 检查是否需要修复Python命令
    if [[ -d "$PROJECT_ROOT" ]]; then
        echo "2. 修复Python命令问题："
        echo "   sudo bash fix-python-commands.sh"
        echo
    fi

    # 服务相关修复
    echo "3. 重启相关服务："
    echo "   sudo systemctl restart nginx"
    echo "   sudo systemctl restart postgresql"
    echo "   sudo systemctl restart redis-server"
    echo "   sudo systemctl restart supervisor"
    echo

    # 权限修复
    echo "4. 修复文件权限："
    echo "   sudo chown -R www-data:www-data $PROJECT_ROOT"
    echo "   sudo chmod -R 755 $PROJECT_ROOT"
    echo

    # 依赖安装
    if [[ -d "$BACKEND_DIR" ]]; then
        echo "5. 重新安装后端依赖："
        echo "   cd $BACKEND_DIR"
        echo "   source venv/bin/activate"
        echo "   pip3 install -r requirements.txt"
        echo
    fi

    if [[ -d "$FRONTEND_DIR" ]]; then
        echo "6. 重新安装前端依赖："
        echo "   cd $FRONTEND_DIR"
        echo "   npm install  # 或 pnpm install"
        echo "   npm run build"
        echo
    fi
}

# 主函数
main() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}    珠海优美化妆品项目 - 部署检查     ${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo

    check_system_services
    echo
    check_project_structure
    echo
    check_python_environment
    echo
    check_nodejs_environment
    echo
    check_database
    echo
    check_nginx_config
    echo
    check_supervisor_config
    echo
    check_firewall
    echo
    check_file_permissions
    echo
    check_ports
    echo
    check_logs
    echo
    generate_diagnostic_report
    echo
    provide_fix_suggestions

    echo
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}           检查完成                   ${NC}"
    echo -e "${BLUE}========================================${NC}"

    if [[ $ISSUES_FOUND -eq 0 ]]; then
        echo -e "${GREEN}状态: 良好 ✓${NC}"
    else
        echo -e "${YELLOW}发现问题: $ISSUES_FOUND 个${NC}"
    fi
}

# 如果直接运行脚本，则执行主函数
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
