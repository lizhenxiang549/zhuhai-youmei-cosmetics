# 珠海优美官网部署指南

> Django 5.2.4 + PostgreSQL 15.13 + Vue 3 + Guerlain风格设计

## 🎯 项目特色

- **现代技术栈**: Django 5.2.4 + Vue 3 + PostgreSQL 15.13
- **Guerlain设计风格**: 黑金优雅主题，高端美妆品牌视觉
- **一键部署**: 支持Docker容器化部署
- **多环境支持**: Win11开发 + 阿里云生产
- **完整功能**: 产品展示、新闻管理、联系表单、管理后台

## 📋 环境要求

### 基础环境
- **Docker**: 20.10+
- **Docker Compose**: 2.0+
- **操作系统**: Linux/Windows/macOS

### 开发环境
- **Python**: 3.11+
- **Node.js**: 18+
- **PostgreSQL**: 15.13+ (可选SQLite)

## 🚀 一键部署

### 方法1: Docker部署（推荐）

```bash
# Linux/macOS
chmod +x deploy.sh
./deploy.sh

# Windows
双击 deploy.bat
```

### 方法2: 手动Docker部署

```bash
# 1. 克隆项目
git clone <repository-url>
cd msd-style-cosmetics

# 2. 启动服务
docker-compose up --build -d

# 3. 查看状态
docker-compose ps

# 4. 查看日志
docker-compose logs -f
```

## 🏢 生产环境部署

### 阿里云ECS部署

```bash
# 1. 连接服务器
ssh root@your-server-ip

# 2. 运行部署脚本
curl -O https://your-domain/aliyun-deploy.sh
chmod +x aliyun-deploy.sh
./aliyun-deploy.sh

# 3. 配置域名（可选）
# 修改 nginx.conf 中的 server_name
# 配置SSL证书到 ./ssl/ 目录
```

### 其他云平台

适用于腾讯云、华为云、AWS等：

```bash
# 1. 安装Docker和Docker Compose
curl -fsSL https://get.docker.com | sh
sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# 2. 克隆项目并部署
git clone <repository-url>
cd msd-style-cosmetics
docker-compose up --build -d
```

## 💻 本地开发环境

### Windows 11开发环境

```bash
# 1. 安装依赖
# Python 3.11+, Node.js 18+, PostgreSQL 15.13

# 2. 后端设置
cd backend
python -m venv venv
venv\Scripts\activate
pip install -r requirements.txt
python manage.py migrate
python manage.py createsuperuser
python manage.py load_sample_data
python manage.py runserver

# 3. 前端设置（新终端）
cd frontend
npm install
npm run dev
```

### 快速开发脚本

```bash
# 使用现有的Windows脚本
双击 start.bat  # 启动开发服务器
双击 stop.bat   # 停止服务
```

## 🗄️ 数据库配置

### PostgreSQL配置（生产推荐）

```bash
# 1. 修改后端 .env 文件
USE_SQLITE=False
DB_NAME=zhuhai_youmei
DB_USER=postgres
DB_PASSWORD=your-secure-password
DB_HOST=localhost  # 或数据库服务器IP
DB_PORT=5432

# 2. 创建数据库
psql -U postgres
CREATE DATABASE zhuhai_youmei;
\q

# 3. 运行迁移
python manage.py migrate
python manage.py load_sample_data
```

### SQLite配置（开发环境）

```bash
# 1. 修改后端 .env 文件
USE_SQLITE=True

# 2. 运行迁移
python manage.py migrate
python manage.py load_sample_data
```

## 🌐 域名和SSL配置

### 1. 域名配置

修改 `nginx.conf` 文件：

```nginx
server {
    listen 80;
    server_name youmei.com www.youmei.com;  # 替换为你的域名
    # ... 其他配置
}
```

### 2. SSL证书配置

```bash
# 1. 将SSL证书放到 ssl/ 目录
mkdir ssl
cp your-certificate.crt ssl/certificate.crt
cp your-private-key.key ssl/private.key

# 2. 启用nginx.conf中的HTTPS配置
# 取消注释HTTPS server块

# 3. 重启nginx
docker-compose restart nginx
```

### 3. 免费SSL证书（Let's Encrypt）

```bash
# 1. 安装certbot
sudo apt install certbot python3-certbot-nginx

# 2. 获取证书
sudo certbot --nginx -d youmei.com -d www.youmei.com

# 3. 自动续期
sudo crontab -e
# 添加：0 12 * * * /usr/bin/certbot renew --quiet
```

## 📊 监控和维护

### 服务状态检查

```bash
# 查看所有容器状态
docker-compose ps

# 查看实时日志
docker-compose logs -f

# 查看特定服务日志
docker-compose logs -f backend
docker-compose logs -f frontend
docker-compose logs -f nginx
```

### 数据备份

```bash
# 1. 数据库备份
docker-compose exec db pg_dump -U postgres zhuhai_youmei > backup.sql

# 2. 媒体文件备份
docker-compose exec backend tar -czf media_backup.tar.gz media/

# 3. 定期自动备份脚本
#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
docker-compose exec db pg_dump -U postgres zhuhai_youmei > backup_$DATE.sql
```

### 服务更新

```bash
# 1. 更新代码
git pull origin main

# 2. 重新构建并重启
docker-compose up --build -d

# 3. 运行数据库迁移（如有需要）
docker-compose exec backend python manage.py migrate
```

## 🔧 常见问题解决

### 1. 端口占用

```bash
# 查看端口占用
netstat -tulpn | grep :80
netstat -tulpn | grep :443

# 停止占用进程
sudo kill -9 <进程ID>
```

### 2. 权限问题

```bash
# 修复Docker权限
sudo usermod -aG docker $USER
newgrp docker

# 修复文件权限
sudo chown -R $USER:$USER .
```

### 3. 数据库连接失败

```bash
# 检查数据库容器状态
docker-compose logs db

# 重启数据库
docker-compose restart db

# 检查数据库连接
docker-compose exec backend python manage.py dbshell
```

### 4. 前端构建失败

```bash
# 清理node_modules重新安装
docker-compose exec frontend rm -rf node_modules
docker-compose exec frontend npm install

# 或重新构建容器
docker-compose build --no-cache frontend
```

## 📞 技术支持

### 项目信息
- **公司**: 珠海优美化妆品有限公司
- **电话**: 13727893557
- **邮箱**: 785981881@qq.com

### 管理后台
- **访问地址**: http://your-domain/admin
- **默认账号**: admin / admin123
- **功能**: 产品管理、新闻发布、订单查看、用户管理

### API接口
- **文档地址**: http://your-domain/api/
- **主要接口**:
  - 首页数据: `/api/homepage/`
  - 产品列表: `/api/products/`
  - 新闻列表: `/api/news/`
  - 联系表单: `/api/contact-messages/`

## 🎨 设计特色

### Guerlain风格主题
- **色彩**: 黑色、白色、金色优雅搭配
- **排版**: 高端品牌级别的视觉设计
- **交互**: 流畅的用户体验
- **响应式**: 完美适配各种设备

### 品牌定位
- **目标**: 高端美妆代工制造商
- **风格**: 专业、优雅、可信赖
- **特色**: 突出产品质量和技术实力

---

🎉 **部署完成后，你将拥有一个完整的企业级美妆官网！**
