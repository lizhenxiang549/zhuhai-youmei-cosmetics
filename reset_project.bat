@echo off
chcp 65001 >nul
title 项目完全重置

echo.
echo ==========================================
echo         项目完全重置
echo ==========================================
echo.
echo 警告: 此操作将删除所有本地数据和配置
echo 如果只是数据库问题，建议先尝试 fix_database.bat
echo.
set /p confirm=确定要继续吗？(y/N):
if /i not "%confirm%"=="y" (
    echo 操作已取消
    pause
    exit /b
)

echo.
echo 正在重置项目...

echo 1. 停止所有相关服务...
taskkill /f /im python.exe >nul 2>&1
taskkill /f /im node.exe >nul 2>&1

echo 2. 清理后端环境...
cd backend

if exist "venv" (
    echo    删除虚拟环境...
    rmdir /s /q venv
)

if exist "db.sqlite3" (
    echo    删除数据库文件...
    del /f db.sqlite3
)

if exist "core\migrations\0001_initial.py" (
    echo    清理迁移文件...
    del /f core\migrations\0001_initial.py
)

if exist "core\migrations\__pycache__" (
    rmdir /s /q core\migrations\__pycache__
)

if exist "core\__pycache__" (
    rmdir /s /q core\__pycache__
)

if exist "cosmetics_msd\__pycache__" (
    rmdir /s /q cosmetics_msd\__pycache__
)

echo 3. 清理前端环境...
cd ..\frontend

if exist "node_modules" (
    echo    删除 node_modules...
    rmdir /s /q node_modules
)

if exist "dist" (
    echo    删除构建文件...
    rmdir /s /q dist
)

echo 4. 重新创建后端环境...
cd ..\backend

echo    创建虚拟环境...
python -m venv venv
if %errorlevel% neq 0 (
    echo    [✗] 虚拟环境创建失败
    goto :error
)

echo    激活虚拟环境...
call .\venv\Scripts\activate.bat

echo    安装后端依赖...
pip install -r requirements.txt
if %errorlevel% neq 0 (
    echo    [✗] 后端依赖安装失败
    goto :error
)

echo    创建数据库迁移...
python manage.py makemigrations
if %errorlevel% neq 0 (
    echo    [✗] 迁移创建失败
    goto :error
)

echo    应用数据库迁移...
python manage.py migrate
if %errorlevel% neq 0 (
    echo    [✗] 数据库迁移失败
    goto :error
)

echo    创建管理员账号...
echo from django.contrib.auth.models import User; User.objects.create_superuser('admin', 'admin@example.com', 'admin123') | python manage.py shell

echo    加载示例数据...
python manage.py load_sample_data
if %errorlevel% neq 0 (
    echo    [✗] 示例数据加载失败
    goto :error
)

echo 5. 重新安装前端依赖...
cd ..\frontend

if exist "%APPDATA%\npm\bun.cmd" (
    echo    使用 bun 安装依赖...
    bun install
) else (
    echo    使用 npm 安装依赖...
    npm install
)

if %errorlevel% neq 0 (
    echo    [✗] 前端依赖安装失败
    goto :error
)

echo.
echo ==========================================
echo         重置完成！
echo ==========================================
echo.
echo 项目已完全重置，现在可以运行 start.bat 启动服务
echo.
goto :end

:error
echo.
echo ==========================================
echo         重置失败
echo ==========================================
echo.
echo 请检查网络连接和软件安装，然后重试
echo 或运行 diagnose.bat 检查环境问题
echo.

:end
pause
