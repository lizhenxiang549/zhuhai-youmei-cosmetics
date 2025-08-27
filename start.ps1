# 美妆代工厂网站启动脚本 (PowerShell版本)
param(
    [switch]$SkipBrowser
)

# 设置控制台编码
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "         美妆代工厂官网启动器" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# 检查执行策略
$executionPolicy = Get-ExecutionPolicy
if ($executionPolicy -eq "Restricted") {
    Write-Host "[警告] PowerShell执行策略受限" -ForegroundColor Yellow
    Write-Host "正在设置执行策略..." -ForegroundColor Yellow
    try {
        Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
        Write-Host "[✓] 执行策略已更新" -ForegroundColor Green
    }
    catch {
        Write-Host "[错误] 无法设置执行策略，请以管理员身份运行" -ForegroundColor Red
        Write-Host "或手动运行: Set-ExecutionPolicy RemoteSigned" -ForegroundColor Yellow
        pause
        exit 1
    }
}

Write-Host "检查环境..." -ForegroundColor Yellow

# 检查Python
try {
    $pythonVersion = python --version 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[✓] 找到 $pythonVersion" -ForegroundColor Green
    } else {
        throw "Python not found"
    }
}
catch {
    Write-Host "[错误] 未找到Python，请先安装Python 3.11+" -ForegroundColor Red
    Write-Host "下载地址: https://www.python.org/downloads/windows/" -ForegroundColor Yellow
    pause
    exit 1
}

# 检查Node.js
try {
    $nodeVersion = node --version 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[✓] 找到 Node.js $nodeVersion" -ForegroundColor Green
    } else {
        throw "Node.js not found"
    }
}
catch {
    Write-Host "[错误] 未找到Node.js，请先安装Node.js 18+" -ForegroundColor Red
    Write-Host "下载地址: https://nodejs.org/" -ForegroundColor Yellow
    pause
    exit 1
}

Write-Host ""
Write-Host "1. 准备后端环境..." -ForegroundColor Yellow

# 进入后端目录
Set-Location backend

# 检查并创建虚拟环境
if (!(Test-Path "venv")) {
    Write-Host "   创建Python虚拟环境..." -ForegroundColor Gray
    python -m venv venv
}

# 激活虚拟环境
Write-Host "   激活虚拟环境..." -ForegroundColor Gray
if (Test-Path "venv\Scripts\Activate.ps1") {
    & .\venv\Scripts\Activate.ps1
} else {
    Write-Host "[错误] 虚拟环境创建失败" -ForegroundColor Red
    pause
    exit 1
}

# 检查Django是否已安装
$djangoInstalled = Test-Path "venv\Lib\site-packages\django"
if (!$djangoInstalled) {
    Write-Host "   安装后端依赖..." -ForegroundColor Gray
    pip install -r requirements.txt
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[错误] 依赖安装失败" -ForegroundColor Red
        pause
        exit 1
    }
}

# 检查数据库
if (!(Test-Path "db.sqlite3")) {
    Write-Host "   初始化数据库..." -ForegroundColor Gray
    python manage.py migrate

    Write-Host "   创建管理员账号..." -ForegroundColor Gray
    $createUser = @"
from django.contrib.auth.models import User
if not User.objects.filter(username='admin').exists():
    User.objects.create_superuser('admin', 'admin@example.com', 'admin123')
    print('管理员账号创建成功')
else:
    print('管理员账号已存在')
"@
    $createUser | python manage.py shell

    Write-Host "   加载示例数据..." -ForegroundColor Gray
    python manage.py load_sample_data
}

# 启动后端服务
Write-Host "   启动后端服务..." -ForegroundColor Gray
$backendJob = Start-Job -ScriptBlock {
    Set-Location $using:PWD
    & .\venv\Scripts\Activate.ps1
    python manage.py runserver 0.0.0.0:8000
}

Write-Host ""
Write-Host "2. 准备前端环境..." -ForegroundColor Yellow

# 进入前端目录
Set-Location ..\frontend

# 检查node_modules
if (!(Test-Path "node_modules")) {
    Write-Host "   安装前端依赖..." -ForegroundColor Gray

    # 检查是否有bun
    $bunExists = Get-Command bun -ErrorAction SilentlyContinue
    if ($bunExists) {
        bun install
    } else {
        npm install
    }

    if ($LASTEXITCODE -ne 0) {
        Write-Host "[错误] 前端依赖安装失败" -ForegroundColor Red
        Stop-Job $backendJob
        Remove-Job $backendJob
        pause
        exit 1
    }
}

# 启动前端服务
Write-Host "   启动前端服务..." -ForegroundColor Gray
$frontendJob = Start-Job -ScriptBlock {
    Set-Location $using:PWD
    $bunExists = Get-Command bun -ErrorAction SilentlyContinue
    if ($bunExists) {
        bun run dev
    } else {
        npm run dev
    }
}

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "           启动完成！" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "服务地址:" -ForegroundColor Green
Write-Host "  前端网站: " -NoNewline; Write-Host "http://localhost:3000" -ForegroundColor Blue
Write-Host "  后端API:  " -NoNewline; Write-Host "http://localhost:8000" -ForegroundColor Blue
Write-Host "  管理后台: " -NoNewline; Write-Host "http://localhost:8000/admin" -ForegroundColor Blue
Write-Host ""
Write-Host "管理员账号: " -NoNewline; Write-Host "admin" -ForegroundColor Yellow
Write-Host "管理员密码: " -NoNewline; Write-Host "admin123" -ForegroundColor Yellow
Write-Host ""
Write-Host "注意: 请等待约10-30秒让服务完全启动" -ForegroundColor Gray
Write-Host "      Django的WARNING消息是正常的开发服务器提示" -ForegroundColor Gray
Write-Host ""

# 等待服务启动
Start-Sleep -Seconds 5

# 自动打开浏览器
if (!$SkipBrowser) {
    Write-Host "正在打开浏览器..." -ForegroundColor Gray
    Start-Process "http://localhost:3000"
}

Write-Host "按 Ctrl+C 停止服务，或关闭此窗口" -ForegroundColor Yellow
Write-Host ""

try {
    # 等待作业完成或用户中断
    while ($backendJob.State -eq "Running" -and $frontendJob.State -eq "Running") {
        Start-Sleep -Seconds 1
    }
}
catch {
    Write-Host ""
    Write-Host "正在停止服务..." -ForegroundColor Yellow
}
finally {
    # 清理作业
    Stop-Job $backendJob, $frontendJob -ErrorAction SilentlyContinue
    Remove-Job $backendJob, $frontendJob -ErrorAction SilentlyContinue
    Write-Host "服务已停止" -ForegroundColor Green
}
