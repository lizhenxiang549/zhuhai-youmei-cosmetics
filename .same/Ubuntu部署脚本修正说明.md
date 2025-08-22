# Ubuntu 22.04 部署脚本修正说明

## 🔧 修正内容

根据您的反馈，我已经修正了Ubuntu 22.04一键部署脚本中的问题：

### 📁 目录结构修正

**修正前（错误）:**
```bash
PROJECT_DIR="/var/www/zhuhai-youmei"
前端目录: /var/www/zhuhai-youmei/frontend
后端目录: /var/www/zhuhai-youmei/backend
```

**修正后（正确）:**
```bash
PROJECT_DIR="/var/www/zhuhai-youmei/ym-cosmetics"
前端目录: /var/www/zhuhai-youmei/ym-cosmetics/frontend
后端目录: /var/www/zhuhai-youmei/ym-cosmetics/backend
```

### 🐍 Python命令修正

**修正前（错误）:**
```bash
python -m venv venv
python manage.py migrate
pip install django
```

**修正后（正确）:**
```bash
python3 -m venv venv
python3 manage.py migrate
pip3 install django
```

---

## 📋 完整的目录结构

修正后的脚本将创建以下目录结构：

```
/var/www/zhuhai-youmei/
└── ym-cosmetics/                    # 项目根目录
    ├── backend/                     # Django后端
    │   ├── zhuhai_youmei/          # Django项目
    │   ├── products/               # 产品应用
    │   ├── news/                   # 新闻应用
    │   ├── company/                # 公司应用
    │   ├── contact/                # 联系应用
    │   ├── venv/                   # Python虚拟环境
    │   ├── media/                  # 媒体文件
    │   ├── staticfiles/            # 静态文件
    │   ├── manage.py               # Django管理脚本
    │   ├── requirements.txt        # Python依赖
    │   └── .env                    # 环境配置
    ├── frontend/                   # Vue前端
    │   ├── src/                    # 源代码
    │   ├── dist/                   # 构建输出
    │   ├── package.json            # Node.js依赖
    │   └── .env.production         # 生产环境配置
    ├── logs/                       # 日志文件
    │   ├── backend.log
    │   ├── backend_error.log
    │   ├── gunicorn_error.log
    │   └── gunicorn_access.log
    ├── backups/                    # 备份文件
    └── scripts/                    # 管理脚本
        ├── deploy.sh               # 部署脚本
        ├── logs.sh                 # 日志查看
        ├── backup.sh               # 备份脚本
        └── status.sh               # 状态监控
```

---

## 🚀 使用修正版脚本

### 1. 下载修正版脚本
```bash
# 下载修正版脚本
wget https://raw.githubusercontent.com/your-repo/Ubuntu22.04一键部署脚本-修正版.sh
chmod +x Ubuntu22.04一键部署脚本-修正版.sh
```

### 2. 执行部署
```bash
# 运行部署脚本
./Ubuntu22.04一键部署脚本-修正版.sh

# 脚本将引导您输入配置信息
```

### 3. 配置信息示例
```bash
请输入域名 (例如: example.com，留空使用IP): youmei.com
请输入管理员邮箱 (用于SSL证书): admin@youmei.com
请设置数据库密码 (至少8位): [输入密码]
请设置Redis密码 (至少8位): [输入密码]
请设置Django管理员密码 (至少8位): [输入密码]
```

### 4. 部署完成后的访问地址
```bash
前端网站: https://youmei.com
管理后台: https://youmei.com/api/admin/
API接口: https://youmei.com/api/
```

---

## 🔧 修正的技术细节

### Python命令兼容性
在Ubuntu 22.04中：
- `python` 命令可能不存在或指向Python 2.7
- `python3` 命令明确指向Python 3.x
- 脚本现在使用 `python3` 和 `pip3` 确保兼容性

### 路径配置修正
所有涉及路径的配置都已更新：

**Nginx配置：**
```nginx
# 前端静态文件
root /var/www/zhuhai-youmei/ym-cosmetics/frontend/dist;

# Django静态文件
location /static/ {
    alias /var/www/zhuhai-youmei/ym-cosmetics/backend/staticfiles/;
}

# Django媒体文件
location /media/ {
    alias /var/www/zhuhai-youmei/ym-cosmetics/backend/media/;
}
```

**Supervisor配置：**
```ini
[program:zhuhai-youmei-backend]
command=/var/www/zhuhai-youmei/ym-cosmetics/backend/venv/bin/gunicorn --config gunicorn.conf.py zhuhai_youmei.wsgi:application
directory=/var/www/zhuhai-youmei/ym-cosmetics/backend
```

**管理脚本路径：**
```bash
PROJECT_DIR="/var/www/zhuhai-youmei/ym-cosmetics"
BACKEND_DIR="/var/www/zhuhai-youmei/ym-cosmetics/backend"
FRONTEND_DIR="/var/www/zhuhai-youmei/ym-cosmetics/frontend"
```

---

## ✅ 验证修正结果

部署完成后，可以通过以下命令验证目录结构：

```bash
# 检查项目目录结构
ls -la /var/www/zhuhai-youmei/ym-cosmetics/
ls -la /var/www/zhuhai-youmei/ym-cosmetics/backend/
ls -la /var/www/zhuhai-youmei/ym-cosmetics/frontend/

# 检查Python版本
python3 --version
pip3 --version

# 检查服务状态
sudo supervisorctl status zhuhai-youmei-backend
sudo systemctl status nginx

# 测试API健康检查
curl http://localhost:8000/health/

# 测试前端访问
curl http://localhost/
```

---

## 🚨 常见问题解决

### 1. Python命令不存在
```bash
# 如果python3命令不存在
sudo apt update
sudo apt install python3 python3-pip python3-venv

# 创建软链接（可选）
sudo ln -sf /usr/bin/python3 /usr/local/bin/python3
```

### 2. 权限问题
```bash
# 修复项目目录权限
sudo chown -R $USER:$USER /var/www/zhuhai-youmei
sudo chmod -R 755 /var/www/zhuhai-youmei
```

### 3. 服务启动失败
```bash
# 检查后端服务
sudo supervisorctl status zhuhai-youmei-backend
sudo supervisorctl restart zhuhai-youmei-backend

# 检查Nginx配置
sudo nginx -t
sudo systemctl restart nginx
```

### 4. 数据库连接问题
```bash
# 检查PostgreSQL服务
sudo systemctl status postgresql
sudo -u postgres psql -l

# 测试数据库连接
sudo -u postgres psql -d zhuhai_youmei -U deploy
```

---

## 📞 获取支持

如果在使用修正版脚本时遇到问题：

1. **查看详细日志：**
   ```bash
   /var/www/zhuhai-youmei/ym-cosmetics/scripts/logs.sh all
   ```

2. **检查系统状态：**
   ```bash
   /var/www/zhuhai-youmei/ym-cosmetics/scripts/status.sh
   ```

3. **手动验证步骤：**
   ```bash
   ./Ubuntu22.04一键部署脚本-修正版.sh verify
   ```

---

## 🎉 修正版特色

✅ **正确的目录结构** - 符合您的项目要求
✅ **Python3兼容性** - 确保在Ubuntu 22.04上正常运行
✅ **完整的路径配置** - 所有配置文件使用正确路径
✅ **详细的错误处理** - 提供清晰的错误信息和解决方案
✅ **自动化验证** - 部署完成后自动验证所有服务状态

现在的脚本已经完全符合您的要求，可以安全地在Ubuntu 22.04上部署！
