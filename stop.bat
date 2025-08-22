@echo off
chcp 65001 >nul
title 停止美妆代工厂网站服务

echo.
echo ==========================================
echo         停止网站服务
echo ==========================================
echo.

echo 正在停止服务...

REM 停止Django进程
echo 停止Django后端服务...
for /f "tokens=2" %%i in ('tasklist /fi "windowtitle eq Django Backend*" /fo list ^| find "PID:"') do (
    taskkill /f /pid %%i >nul 2>&1
)

REM 停止Node.js/Vite进程
echo 停止Vue前端服务...
for /f "tokens=2" %%i in ('tasklist /fi "windowtitle eq Vue Frontend*" /fo list ^| find "PID:"') do (
    taskkill /f /pid %%i >nul 2>&1
)

REM 停止可能的Python进程
tasklist /fi "imagename eq python.exe" /fo csv | find /c "python.exe" >nul
if %errorlevel% equ 0 (
    echo 停止Python进程...
    taskkill /f /im python.exe >nul 2>&1
)

REM 停止可能的Node.js进程
tasklist /fi "imagename eq node.exe" /fo csv | find /c "node.exe" >nul
if %errorlevel% equ 0 (
    echo 停止Node.js进程...
    taskkill /f /im node.exe >nul 2>&1
)

echo.
echo [✓] 所有服务已停止

echo.
echo 如需重新启动，请运行 start.bat
echo.
pause
