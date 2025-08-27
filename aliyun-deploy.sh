#!/bin/bash

echo "======================================"
echo "    珠海优美官网阿里云部署脚本"
echo "======================================"

# 更新系统
echo "📦 更新系统包..."
sudo yum update -y

# 安装Docker
echo "🐳 安装Docker..."
sudo yum install -y docker
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER

# 安装Docker Compose
echo "🔧 安装Docker Compose..."
sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# 创建项目目录
echo "📁 创建项目目录..."
mkdir -p /home/youmei-website
cd /home/youmei-website

# 如果有Git仓库，克隆代码
# git clone YOUR_REPOSITORY_URL .

# 设置环境变量
echo "⚙️ 配置环境变量..."
cat > .env << EOF
# 生产环境配置
DEBUG=False
SECRET_KEY=your-secret-key-here-change-in-production
ALLOWED_HOSTS=your-domain.com,www.your-domain.com,localhost
USE_SQLITE=False
DB_NAME=zhuhai_youmei
DB_USER=postgres
DB_PASSWORD=your-secure-password
DB_HOST=db
DB_PORT=5432
EOF

# 配置防火墙
echo "🔥 配置防火墙..."
sudo firewall-cmd --permanent --add-port=80/tcp
sudo firewall-cmd --permanent --add-port=443/tcp
sudo firewall-cmd --permanent --add-port=8000/tcp
sudo firewall-cmd --permanent --add-port=3000/tcp
sudo firewall-cmd --reload

# 启动服务
echo "🚀 启动服务..."
docker-compose up --build -d

# 等待服务启动
echo "⏳ 等待服务启动..."
sleep 60

# 检查服务状态
echo "📊 检查服务状态..."
docker-compose ps

# 显示访问信息
echo ""
echo "======================================"
echo "         阿里云部署完成！"
echo "======================================"
echo "🌐 外网访问: http://$(curl -s ifconfig.me)"
echo "🔧 管理后台: http://$(curl -s ifconfig.me)/admin"
echo "👤 管理员账号: admin / admin123"
echo "📞 联系电话: 13727893557"
echo "📧 联系邮箱: 785981881@qq.com"
echo ""
echo "⚠️  请记得："
echo "1. 修改数据库密码"
echo "2. 配置域名和SSL证书"
echo "3. 定期备份数据"
echo "======================================"
