@echo off
chcp 65001 >nul
title 数据库修复工具

echo.
echo ==========================================
echo         数据库修复工具
echo ==========================================
echo.

echo 正在修复数据库问题...
echo.

cd backend

echo 1. 激活Python虚拟环境...
call .\venv\Scripts\activate.bat

echo 2. 停止可能运行的服务...
taskkill /f /im python.exe >nul 2>&1

echo 3. 删除旧的数据库文件...
if exist "db.sqlite3" (
    del /f db.sqlite3
    echo    [✓] 删除 db.sqlite3
)

echo 4. 清理迁移文件...
if exist "core\migrations\0001_initial.py" (
    del /f core\migrations\0001_initial.py
    echo    [✓] 清理旧迁移文件
)

if exist "core\migrations\__pycache__" (
    rmdir /s /q core\migrations\__pycache__
    echo    [✓] 清理迁移缓存
)

echo 5. 重新创建迁移文件...
python manage.py makemigrations
if %errorlevel% neq 0 (
    echo    [✗] 迁移文件创建失败
    goto :error
)

echo 6. 应用数据库迁移...
python manage.py migrate
if %errorlevel% neq 0 (
    echo    [✗] 数据库迁移失败
    goto :error
)

echo 7. 创建管理员账号...
echo from django.contrib.auth.models import User; User.objects.get_or_create(username='admin', defaults={'email': 'admin@example.com', 'is_staff': True, 'is_superuser': True}); u = User.objects.get(username='admin'); u.set_password('admin123'); u.save(); print('管理员账号已设置') | python manage.py shell

echo 8. 加载示例数据...
python manage.py load_sample_data
if %errorlevel% neq 0 (
    echo    [✗] 示例数据加载失败
    goto :error
)

echo.
echo ==========================================
echo         修复完成！
echo ==========================================
echo.
echo 数据库已成功修复，现在可以正常启动网站了
echo 请运行 start.bat 启动服务
echo.
goto :end

:error
echo.
echo ==========================================
echo         修复失败
echo ==========================================
echo.
echo 请检查以下问题：
echo 1. Python是否正确安装
echo 2. 虚拟环境是否正确创建
echo 3. 依赖是否完整安装
echo.
echo 建议运行 diagnose.bat 检查环境
echo.

:end
pause
