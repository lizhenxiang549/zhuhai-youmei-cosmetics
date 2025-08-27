#!/bin/bash

# Python命令修复脚本 - Ubuntu 22.04
# 修复所有使用python命令的地方为python3

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

# 项目路径
PROJECT_ROOT="/var/www/zhuhai-youmei/ym-cosmetics"
BACKEND_DIR="$PROJECT_ROOT/backend"

log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}"
}

warn() {
    echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] WARNING: $1${NC}"
}

error() {
    echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ERROR: $1${NC}"
}

# 修复项目中的Python命令
fix_python_commands() {
    log "修复项目中的Python命令..."

    # 检查项目目录是否存在
    if [[ ! -d "$PROJECT_ROOT" ]]; then
        error "项目目录不存在: $PROJECT_ROOT"
    fi

    cd "$PROJECT_ROOT"

    # 查找并修复所有脚本文件中的python命令
    log "搜索需要修复的文件..."

    # 修复shell脚本中的python命令
    find . -name "*.sh" -type f -exec grep -l "python " {} \; | while read file; do
        log "修复文件: $file"
        sed -i 's/\bpython /python3 /g' "$file"
        sed -i 's/\bpython$/python3/g' "$file"
    done

    # 修复Makefile中的python命令
    find . -name "Makefile" -o -name "makefile" -type f -exec grep -l "python " {} \; | while read file; do
        log "修复Makefile: $file"
        sed -i 's/\bpython /python3 /g' "$file"
    done

    # 修复package.json中的scripts
    find . -name "package.json" -type f | while read file; do
        if grep -q '"python ' "$file"; then
            log "修复package.json: $file"
            sed -i 's/"python /"python3 /g' "$file"
        fi
    done

    # 修复Docker相关文件
    find . -name "Dockerfile" -o -name "docker-compose.yml" -o -name "docker-compose.yaml" -type f | while read file; do
        if grep -q "python " "$file"; then
            log "修复Docker文件: $file"
            sed -i 's/\bpython /python3 /g' "$file"
        fi
    done

    # 修复requirements.txt中可能的python引用
    find . -name "requirements.txt" -type f | while read file; do
        if grep -q "python=" "$file"; then
            log "修复requirements.txt: $file"
            sed -i 's/python=/python3=/g' "$file"
        fi
    done

    # 修复Python脚本的shebang
    find . -name "*.py" -type f | while read file; do
        if head -n1 "$file" | grep -q "#!/usr/bin/env python$"; then
            log "修复Python脚本shebang: $file"
            sed -i '1s|#!/usr/bin/env python$|#!/usr/bin/env python3|' "$file"
        elif head -n1 "$file" | grep -q "#!/usr/bin/python$"; then
            log "修复Python脚本shebang: $file"
            sed -i '1s|#!/usr/bin/python$|#!/usr/bin/python3|' "$file"
        fi
    done

    log "Python命令修复完成"
}

# 修复Supervisor配置
fix_supervisor_config() {
    log "修复Supervisor配置中的Python命令..."

    local config_file="/etc/supervisor/conf.d/zhuhai-youmei-backend.conf"

    if [[ -f "$config_file" ]]; then
        if grep -q "python " "$config_file"; then
            log "修复Supervisor配置: $config_file"
            sed -i 's|/python |/python3 |g' "$config_file"
            supervisorctl reread
            supervisorctl update
        fi
    else
        warn "Supervisor配置文件不存在: $config_file"
    fi
}

# 修复systemd服务文件
fix_systemd_services() {
    log "修复systemd服务文件中的Python命令..."

    find /etc/systemd/system -name "*youmei*" -o -name "*cosmetics*" | while read file; do
        if [[ -f "$file" ]] && grep -q "python " "$file"; then
            log "修复systemd服务: $file"
            sed -i 's/\bpython /python3 /g' "$file"
            systemctl daemon-reload
        fi
    done
}

# 修复crontab任务
fix_crontab() {
    log "检查crontab中的Python命令..."

    # 备份当前crontab
    crontab -l > /tmp/crontab_backup 2>/dev/null || true

    if [[ -f /tmp/crontab_backup ]] && grep -q "python " /tmp/crontab_backup; then
        log "修复crontab中的Python命令..."
        sed 's/\bpython /python3 /g' /tmp/crontab_backup | crontab -
        rm /tmp/crontab_backup
    fi
}

# 创建Python别名（可选）
create_python_alias() {
    log "是否创建python到python3的别名？"
    read -p "输入 y/n: " -n 1 -r
    echo

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # 为系统用户创建别名
        if ! grep -q "alias python=python3" /etc/bash.bashrc; then
            echo "alias python=python3" >> /etc/bash.bashrc
            log "已添加系统级python别名"
        fi

        # 为www-data用户创建别名
        if [[ -f /var/www/.bashrc ]]; then
            if ! grep -q "alias python=python3" /var/www/.bashrc; then
                echo "alias python=python3" >> /var/www/.bashrc
            fi
        fi

        log "Python别名创建完成"
    else
        log "跳过Python别名创建"
    fi
}

# 验证Python环境
verify_python_environment() {
    log "验证Python环境..."

    # 检查Python3是否安装
    if command -v python3 &> /dev/null; then
        python_version=$(python3 --version)
        log "Python3版本: $python_version"
    else
        error "Python3未安装"
    fi

    # 检查pip3是否安装
    if command -v pip3 &> /dev/null; then
        pip_version=$(pip3 --version)
        log "pip3版本: $pip_version"
    else
        warn "pip3未安装，正在安装..."
        apt update && apt install -y python3-pip
    fi

    # 检查虚拟环境
    if [[ -d "$BACKEND_DIR/venv" ]]; then
        log "虚拟环境存在: $BACKEND_DIR/venv"

        # 检查虚拟环境中的Python版本
        venv_python_version=$("$BACKEND_DIR/venv/bin/python" --version)
        log "虚拟环境Python版本: $venv_python_version"
    else
        warn "虚拟环境不存在，需要创建"
    fi
}

# 重新创建虚拟环境（如果需要）
recreate_virtual_environment() {
    log "是否重新创建Python虚拟环境？"
    read -p "输入 y/n: " -n 1 -r
    echo

    if [[ $REPLY =~ ^[Yy]$ ]]; then
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

        # 重新安装依赖
        if [[ -f "requirements.txt" ]]; then
            python3 -m pip install -r requirements.txt
            log "依赖重新安装完成"
        fi

        deactivate
        log "虚拟环境重新创建完成"
    fi
}

# 测试Python应用
test_python_application() {
    log "测试Python应用..."

    cd "$BACKEND_DIR"

    if [[ -f "app.py" ]]; then
        source venv/bin/activate

        # 测试Python语法
        python3 -m py_compile app.py
        log "Python语法检查通过"

        # 测试导入
        python3 -c "import app" 2>/dev/null && log "应用导入测试通过" || warn "应用导入测试失败"

        deactivate
    else
        warn "未找到app.py文件"
    fi
}

# 生成修复报告
generate_fix_report() {
    log "生成修复报告..."

    local report_file="/tmp/python_fix_report_$(date +%Y%m%d_%H%M%S).txt"

    cat > "$report_file" << EOF
Python命令修复报告
==================
日期: $(date)
项目: 珠海优美化妆品项目

修复的文件:
-----------
EOF

    # 查找所有可能包含python3的文件
    find "$PROJECT_ROOT" -type f \( -name "*.sh" -o -name "*.py" -o -name "Makefile" -o -name "package.json" \) -exec grep -l "python3" {} \; >> "$report_file"

    echo >> "$report_file"
    echo "系统Python环境:" >> "$report_file"
    python3 --version >> "$report_file" 2>&1
    pip3 --version >> "$report_file" 2>&1

    echo >> "$report_file"
    echo "虚拟环境信息:" >> "$report_file"
    if [[ -d "$BACKEND_DIR/venv" ]]; then
        "$BACKEND_DIR/venv/bin/python" --version >> "$report_file" 2>&1
    else
        echo "虚拟环境不存在" >> "$report_file"
    fi

    log "修复报告已生成: $report_file"
}

# 主函数
main() {
    log "开始修复Python命令问题..."

    verify_python_environment
    fix_python_commands
    fix_supervisor_config
    fix_systemd_services
    fix_crontab
    create_python_alias
    recreate_virtual_environment
    test_python_application
    generate_fix_report

    log "Python命令修复完成！"
    echo
    echo -e "${GREEN}修复摘要:${NC}"
    echo "1. 所有脚本文件中的python命令已改为python3"
    echo "2. Supervisor配置已更新"
    echo "3. systemd服务文件已更新"
    echo "4. crontab任务已更新"
    echo "5. Python环境已验证"
    echo
    echo -e "${YELLOW}建议后续操作:${NC}"
    echo "1. 重启相关服务: supervisorctl restart zhuhai-youmei-backend"
    echo "2. 测试应用功能"
    echo "3. 检查日志: tail -f /var/log/zhuhai-youmei/backend.log"
}

# 如果直接运行脚本，则执行主函数
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
