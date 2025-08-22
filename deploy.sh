#!/bin/bash

echo "======================================"
echo "       珠海优美官网部署脚本"
echo "======================================"

# 检查Docker是否安装
if ! command -v docker &> /dev/null; then
    echo "❌ Docker未安装，请先安装Docker"
    echo "安装命令: curl -fsSL https://get.docker.com | sh"
    exit 1
fi

# 检查Docker Compose是否安装
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose未安装，请先安装Docker Compose"
    exit 1
fi

echo "✅ 环境检查通过"

# 停止现有容器
echo "🛑 停止现有容器..."
docker-compose down

# 构建并启动服务
echo "🚀 构建并启动服务..."
docker-compose up --build -d

# 等待服务启动
echo "⏳ 等待服务启动..."
sleep 30

# 检查服务状态
echo "📊 检查服务状态..."
docker-compose ps

# 显示访问信息
echo ""
echo "======================================"
echo "           部署完成！"
echo "======================================"
echo "🌐 网站地址: http://localhost"
echo "🔧 管理后台: http://localhost/admin"
echo "👤 管理员账号: admin / admin123"
echo "📞 联系电话: 13727893557"
echo "📧 联系邮箱: 785981881@qq.com"
echo ""
echo "💡 查看日志: docker-compose logs -f"
echo "🛑 停止服务: docker-compose down"
echo "======================================"
