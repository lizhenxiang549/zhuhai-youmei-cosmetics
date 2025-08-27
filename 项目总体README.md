# Ubuntu 22.04 部署脚本集合

针对珠海优美化妆品项目的完整部署解决方案，修复了Ubuntu 22.04中python命令问题。

## 项目结构

```
/var/www/zhuhai-youmei/ym-cosmetics/
├── frontend/          # 前端代码目录
├── backend/           # 后端代码目录
└── ...
```

## 脚本说明

### 1. deploy-ubuntu22.04.sh - 完整部署脚本

**功能**: 从零开始在Ubuntu 22.04上完整部署项目

**安装内容**:
- Node.js 18.x LTS + pnpm
- Python 3.10 + pip3 + 虚拟环境
- MySQL 数据库
- Redis 缓存
- Nginx 反向代理
- Supervisor 进程管理
- UFW 防火墙配置
- SSL证书支持 (Let's Encrypt)

**使用方法**:
```bash
sudo bash deploy-ubuntu22.04.sh
```

**重要提醒**:
- 运行前请修改脚本中的数据库密码和域名配置
- 脚本会自动使用python3命令而不是python

### 2. fix-python-commands.sh - Python命令修复脚本

**功能**: 修复项目中所有使用python命令的地方，改为python3

**修复范围**:
- 所有shell脚本 (*.sh)
- Makefile文件
- package.json中的scripts
- Docker相关文件
- Python脚本的shebang
- Supervisor配置
- systemd服务文件
- crontab任务

**使用方法**:
```bash
sudo bash fix-python-commands.sh
```

### 3. deployment-check.sh - 部署状态检查脚本

**功能**: 全面检查部署状态，诊断常见问题

**检查项目**:
- 系统服务状态 (Nginx, MySQL, Redis, Supervisor)
- 项目目录结构
- Python和Node.js环境
- 数据库连接
- 配置文件语法
- 文件权限
- 端口占用
- 日志文件

**使用方法**:
```bash
bash deployment-check.sh
```

## 快速使用指南

### 全新部署

1. **完整部署**:
   ```bash
   # 下载脚本
   wget https://your-server.com/deploy-ubuntu22.04.sh

   # 修改配置 (数据库密码、域名等)
   nano deploy-ubuntu22.04.sh

   # 运行部署
   sudo bash deploy-ubuntu22.04.sh
   ```

2. **检查部署状态**:
   ```bash
   bash deployment-check.sh
   ```

### 修复现有部署

1. **修复Python命令问题**:
   ```bash
   sudo bash fix-python-commands.sh
   ```

2. **检查问题**:
   ```bash
   bash deployment-check.sh
   ```

3. **重启服务**:
   ```bash
   sudo systemctl restart nginx
   sudo supervisorctl restart zhuhai-youmei-backend
   ```

## 常见问题解决

### 1. Python命令找不到

**错误**: `python: command not found`

**解决**:
```bash
sudo bash fix-python-commands.sh
```

### 2. 虚拟环境问题

**错误**: 虚拟环境无法激活或依赖安装失败

**解决**:
```bash
cd /var/www/zhuhai-youmei/ym-cosmetics/backend
sudo rm -rf venv
python3 -m venv venv
source venv/bin/activate
python3 -m pip install --upgrade pip
python3 -m pip install -r requirements.txt
```

### 3. 前端构建失败

**错误**: npm或node命令找不到

**解决**:
```bash
# 安装Node.js
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo bash -
sudo apt install -y nodejs

# 重新安装依赖
cd /var/www/zhuhai-youmei/ym-cosmetics/frontend
npm install
npm run build
```

### 4. 数据库连接失败

**解决**:
```bash
# 重启MySQL
sudo systemctl restart mysql

# 检查数据库和用户
sudo mysql -e "SHOW DATABASES;" -u root -p
sudo mysql -e "SELECT User, Host FROM mysql.user;" -u root -p
```

### 5. Nginx配置错误

**解决**:
```bash
# 测试配置
sudo nginx -t

# 如果有错误，检查配置文件
sudo nano /etc/nginx/sites-available/ym-cosmetics

# 重启Nginx
sudo systemctl restart nginx
```

### 6. 权限问题

**解决**:
```bash
sudo chown -R www-data:www-data /var/www/zhuhai-youmei
sudo chmod -R 755 /var/www/zhuhai-youmei
sudo mkdir -p /var/log/zhuhai-youmei
sudo chown www-data:www-data /var/log/zhuhai-youmei
```

## 系统管理命令

### 服务管理
```bash
# 查看所有服务状态
sudo systemctl status nginx mysql redis-server supervisor

# 重启所有相关服务
sudo systemctl restart nginx mysql redis-server supervisor

# 查看服务日志
sudo journalctl -u nginx -f
sudo journalctl -u mysql -f
```

### 项目管理
```bash
# 更新项目
sudo /usr/local/bin/update-zhuhai-youmei.sh

# 备份项目
sudo /usr/local/bin/backup-zhuhai-youmei.sh

# 查看后端日志
sudo tail -f /var/log/zhuhai-youmei/backend.log

# 重启后端服务
sudo supervisorctl restart zhuhai-youmei-backend

# 查看Supervisor状态
sudo supervisorctl status
```

### 数据库管理
```bash
# 连接数据库
mysql -u ym_user -p ym_cosmetics

# 备份数据库
mysqldump -u ym_user -p ym_cosmetics > backup_$(date +%Y%m%d).sql

# 恢复数据库
mysql -u ym_user -p ym_cosmetics < backup_20240118.sql
```

## 监控和维护

### 性能监控
```bash
# 查看系统资源
htop
df -h
free -h

# 查看网络连接
netstat -tlnp

# 查看进程
ps aux | grep python
ps aux | grep nginx
```

### 日志分析
```bash
# Nginx访问日志
sudo tail -f /var/log/nginx/ym-cosmetics.access.log

# Nginx错误日志
sudo tail -f /var/log/nginx/ym-cosmetics.error.log

# 系统日志
sudo tail -f /var/log/syslog
```

### 安全检查
```bash
# 防火墙状态
sudo ufw status verbose

# 查看登录记录
sudo last
sudo lastlog

# 检查异常连接
sudo netstat -an | grep :80 | wc -l
```

## 配置文件位置

- **Nginx配置**: `/etc/nginx/sites-available/ym-cosmetics`
- **Supervisor配置**: `/etc/supervisor/conf.d/zhuhai-youmei-backend.conf`
- **Python配置**: `/var/www/zhuhai-youmei/ym-cosmetics/backend/config.py`
- **日志目录**: `/var/log/zhuhai-youmei/`
- **备份目录**: `/var/backups/ym-cosmetics/`

## 技术支持

如果遇到问题，请按以下步骤操作：

1. **运行诊断脚本**: `bash deployment-check.sh`
2. **查看错误日志**: 检查各服务的日志文件
3. **运行修复脚本**: `sudo bash fix-python-commands.sh`
4. **重启相关服务**: 按需重启nginx、mysql、redis等服务

## 注意事项

1. **安全性**: 请及时修改默认密码，启用防火墙
2. **备份**: 定期备份数据库和代码文件
3. **更新**: 定期更新系统和依赖包
4. **监控**: 建议配置监控系统跟踪服务状态
5. **SSL**: 生产环境建议配置SSL证书

## 版本信息

- **Ubuntu**: 22.04 LTS
- **Python**: 3.10+
- **Node.js**: 18.x LTS
- **MySQL**: 8.0+
- **Nginx**: 1.18+
- **Redis**: 6.0+

---

*最后更新: 2024年*
