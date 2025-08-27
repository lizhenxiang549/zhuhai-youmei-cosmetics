@echo off
chcp 65001 >nul
title 珠海优美官网部署

echo ======================================
echo        珠海优美官网部署脚本
echo ======================================
echo.

REM 检查Docker是否安装
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker未安装，请先安装Docker Desktop
    echo 下载地址: https://www.docker.com/products/docker-desktop/
    pause
    exit /b 1
)

REM 检查Docker Compose是否可用
docker-compose --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker Compose不可用
    pause
    exit /b 1
)

echo ✅ 环境检查通过

REM 停止现有容器
echo 🛑 停止现有容器...
docker-compose down

REM 构建并启动服务
echo 🚀 构建并启动服务...
docker-compose up --build -d

REM 等待服务启动
echo ⏳ 等待服务启动...
timeout /t 30 /nobreak >nul

REM 检查服务状态
echo 📊 检查服务状态...
docker-compose ps

echo.
echo ======================================
echo            部署完成！
echo ======================================
echo 🌐 网站地址: http://localhost
echo 🔧 管理后台: http://localhost/admin
echo 👤 管理员账号: admin / admin123
echo 📞 联系电话: 13727893557
echo 📧 联系邮箱: 785981881@qq.com
echo.
echo 💡 查看日志: docker-compose logs -f
echo 🛑 停止服务: docker-compose down
echo ======================================
echo.

REM 自动打开浏览器
start http://localhost

echo 按任意键退出...
pause >nul
