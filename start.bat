@echo off
chcp 65001 >nul
title 美妆代工厂网站启动器

echo.
echo ==========================================
echo         美妆代工厂官网启动器
echo ==========================================
echo.

echo 检查环境...

REM 检查Python
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [错误] 未找到Python，请先安装Python 3.11+
    echo 下载地址: https://www.python.org/downloads/windows/
    pause
    exit /b 1
)

REM 检查Node.js
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [错误] 未找到Node.js，请先安装Node.js 18+
    echo 下载地址: https://nodejs.org/
    pause
    exit /b 1
)

echo [✓] 环境检查通过

echo.
echo 1. 准备后端环境...
cd backend

REM 检查虚拟环境
if not exist "venv" (
    echo    创建Python虚拟环境...
    python -m venv venv
)

echo    激活虚拟环境...
call .\venv\Scripts\activate.bat

echo    检查依赖...
if not exist "venv\Lib\site-packages\django" (
    echo    安装后端依赖...
    pip install -r requirements.txt
)

REM 检查数据库
if not exist "db.sqlite3" (
    echo    初始化数据库...
    python manage.py migrate
    echo    创建管理员账号...
    echo from django.contrib.auth.models import User; User.objects.create_superuser('admin', 'admin@example.com', 'admin123') | python manage.py shell
    echo    加载示例数据...
    python manage.py load_sample_data
)

echo    启动后端服务...
start "Django Backend (端口:8000)" cmd /k "title Django Backend && echo 后端服务运行中... && echo 地址: http://localhost:8000 && echo 管理后台: http://localhost:8000/admin && echo 账号: admin / admin123 && echo. && python manage.py runserver 0.0.0.0:8000"

echo.
echo 2. 准备前端环境...
cd ..\frontend

echo    检查前端依赖...
if not exist "node_modules" (
    echo    安装前端依赖...
    if exist "%APPDATA%\npm\bun.cmd" (
        bun install
    ) else (
        npm install
    )
)

echo    启动前端服务...
if exist "%APPDATA%\npm\bun.cmd" (
    start "Vue Frontend (端口:3000)" cmd /k "title Vue Frontend && echo 前端服务运行中... && echo 地址: http://localhost:3000 && echo. && bun run dev"
) else (
    start "Vue Frontend (端口:3000)" cmd /k "title Vue Frontend && echo 前端服务运行中... && echo 地址: http://localhost:3000 && echo. && npm run dev"
)

echo.
echo ==========================================
echo           启动完成！
echo ==========================================
echo.
echo 服务地址:
echo   前端网站: http://localhost:3000
echo   后端API:  http://localhost:8000
echo   管理后台: http://localhost:8000/admin
echo.
echo 管理员账号: admin
echo 管理员密码: admin123
echo.
echo 注意: 请等待约10-30秒让服务完全启动
echo       如需停止服务，请运行 stop.bat
echo.

timeout /t 3 >nul
start http://localhost:3000

echo 按任意键退出启动器...
pause >nul
