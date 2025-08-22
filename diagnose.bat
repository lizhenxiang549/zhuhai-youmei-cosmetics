@echo off
chcp 65001 >nul
title 美妆代工厂网站问题诊断

echo.
echo ==========================================
echo         系统环境诊断
echo ==========================================
echo.

echo 1. 检查必需软件...
echo.

REM Python检查
echo [Python]
python --version 2>nul
if %errorlevel% equ 0 (
    echo   状态: ✓ 已安装
    python -c "import sys; print(f'   路径: {sys.executable}')"
) else (
    echo   状态: ✗ 未安装或不在PATH中
    echo   解决: 下载安装 https://www.python.org/downloads/windows/
)
echo.

REM Node.js检查
echo [Node.js]
node --version 2>nul
if %errorlevel% equ 0 (
    echo   状态: ✓ 已安装
    echo   NPM版本: && npm --version
) else (
    echo   状态: ✗ 未安装或不在PATH中
    echo   解决: 下载安装 https://nodejs.org/
)
echo.

REM Git检查
echo [Git]
git --version 2>nul
if %errorlevel% equ 0 (
    echo   状态: ✓ 已安装
) else (
    echo   状态: ✗ 未安装 (可选)
    echo   解决: 下载安装 https://git-scm.com/download/win
)
echo.

echo 2. 检查端口占用...
echo.

REM 检查8000端口
echo [端口 8000 - Django后端]
netstat -ano | findstr :8000 >nul
if %errorlevel% equ 0 (
    echo   状态: ✗ 端口被占用
    echo   占用进程:
    for /f "tokens=5" %%a in ('netstat -ano ^| findstr :8000') do (
        tasklist /fi "pid eq %%a" | findstr /v "映像名称"
    )
    echo   解决: 运行 stop.bat 或手动结束进程
) else (
    echo   状态: ✓ 端口可用
)
echo.

REM 检查3000端口
echo [端口 3000 - Vue前端]
netstat -ano | findstr :3000 >nul
if %errorlevel% equ 0 (
    echo   状态: ✗ 端口被占用
    echo   占用进程:
    for /f "tokens=5" %%a in ('netstat -ano ^| findstr :3000') do (
        tasklist /fi "pid eq %%a" | findstr /v "映像名称"
    )
    echo   解决: 运行 stop.bat 或手动结束进程
) else (
    echo   状态: ✓ 端口可用
)
echo.

echo 3. 检查项目文件...
echo.

REM 检查后端文件
echo [后端文件]
if exist "backend\manage.py" (
    echo   manage.py: ✓ 存在
) else (
    echo   manage.py: ✗ 缺失
)

if exist "backend\requirements.txt" (
    echo   requirements.txt: ✓ 存在
) else (
    echo   requirements.txt: ✗ 缺失
)

if exist "backend\venv" (
    echo   虚拟环境: ✓ 存在
    if exist "backend\venv\Scripts\python.exe" (
        echo   Python解释器: ✓ 存在
    ) else (
        echo   Python解释器: ✗ 缺失
    )
) else (
    echo   虚拟环境: ✗ 不存在
    echo   解决: 运行 start.bat 自动创建
)
echo.

REM 检查前端文件
echo [前端文件]
if exist "frontend\package.json" (
    echo   package.json: ✓ 存在
) else (
    echo   package.json: ✗ 缺失
)

if exist "frontend\node_modules" (
    echo   node_modules: ✓ 存在
) else (
    echo   node_modules: ✗ 不存在
    echo   解决: 运行 start.bat 自动安装
)

if exist "frontend\vite.config.ts" (
    echo   vite.config.ts: ✓ 存在
) else (
    echo   vite.config.ts: ✗ 缺失
)
echo.

echo 4. 检查防火墙和网络...
echo.

REM 检查网络连接
ping -n 1 127.0.0.1 >nul
if %errorlevel% equ 0 (
    echo   本地回环: ✓ 正常
) else (
    echo   本地回环: ✗ 异常
)

REM Windows防火墙状态
echo.
echo [Windows防火墙状态]
netsh advfirewall show currentprofile | findstr "状态\|State"

echo.
echo 5. 常见解决方案...
echo.
echo   问题: Python/Node.js命令不识别
echo   解决: 重新安装时勾选"Add to PATH"选项
echo.
echo   问题: 端口被占用
echo   解决: 运行 stop.bat 或重启电脑
echo.
echo   问题: 权限被拒绝
echo   解决: 以管理员身份运行命令提示符
echo.
echo   问题: pip安装失败
echo   解决: pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org -r requirements.txt
echo.
echo   问题: npm安装失败
echo   解决: npm config set registry https://registry.npmmirror.com
echo.

echo ==========================================
echo           诊断完成
echo ==========================================
echo.
echo 如果问题仍未解决，请查看 README.md 获取详细帮助
echo.
pause
