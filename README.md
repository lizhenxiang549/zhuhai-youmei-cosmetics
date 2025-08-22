# 美妆代工厂官网 - Windows 11 部署指南

## 项目简介

基于Django 5.2.4 + Vue 3前后端分离架构的美妆代工厂官网，采用MSD(默沙东)风格设计。

## Windows 11 环境要求

### 必需软件
- **Python 3.11+** [下载地址](https://www.python.org/downloads/windows/)
- **Node.js 18+** [下载地址](https://nodejs.org/en/download/)
- **Git** [下载地址](https://git-scm.com/download/win)

### 可选软件
- **Visual Studio Code** [下载地址](https://code.visualstudio.com/)
- **Windows Terminal** [Microsoft Store](https://apps.microsoft.com/detail/9n0dx20hk701)

## 部署步骤

### 1. 环境准备

```powershell
# 检查Python版本
python --version

# 检查Node.js版本
node --version
npm --version

# 安装Bun（可选，更快的包管理器）
npm install -g bun
```

### 2. 克隆项目（如果从Git）

```powershell
git clone <repository-url>
cd msd-style-cosmetics
```

### 3. 后端部署

```powershell
# 进入后端目录
cd backend

# 创建虚拟环境
python -m venv venv

# 激活虚拟环境（Windows PowerShell）
.\venv\Scripts\Activate.ps1

# 如果遇到执行策略问题，运行：
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# 或者使用cmd激活方式：
# .\venv\Scripts\activate.bat

# 升级pip
python -m pip install --upgrade pip

# 安装依赖
pip install -r requirements.txt

# 数据库迁移
python manage.py migrate

# 创建超级用户
python manage.py createsuperuser
# 或者使用预设账号：
echo "from django.contrib.auth.models import User; User.objects.create_superuser('admin', 'admin@example.com', 'admin123')" | python manage.py shell

# 加载示例数据
python manage.py load_sample_data

# 启动后端服务
python manage.py runserver 0.0.0.0:8000
```

### 4. 前端部署（新开PowerShell窗口）

```powershell
# 进入前端目录
cd frontend

# 安装依赖（使用npm）
npm install

# 或使用bun（更快）
bun install

# 启动开发服务器
npm run dev
# 或
bun run dev
```

## 常见问题解决

### 1. PowerShell执行策略问题

```powershell
# 临时允许脚本执行
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process

# 或永久设置（推荐）
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### 2. 端口占用问题

```powershell
# 检查端口占用
netstat -ano | findstr :8000
netstat -ano | findstr :3000

# 杀死占用进程
taskkill /PID <进程ID> /F

# 或更换端口
python manage.py runserver 0.0.0.0:8001
```

### 3. Python虚拟环境问题

```powershell
# 删除旧环境重新创建
rmdir /s venv
python -m venv venv
.\venv\Scripts\Activate.ps1
pip install -r requirements.txt
```

### 4. Node.js版本问题

```powershell
# 使用nvm管理Node.js版本
# 下载nvm-windows: https://github.com/coreybutler/nvm-windows

nvm install 18.18.0
nvm use 18.18.0
```

## 生产环境部署

### 使用Gunicorn + Nginx（Windows）

1. **安装依赖**
```powershell
pip install gunicorn
```

2. **启动Gunicorn**
```powershell
cd backend
gunicorn cosmetics_msd.wsgi:application --bind 0.0.0.0:8000 --workers 4
```

3. **前端生产构建**
```powershell
cd frontend
npm run build
# 或
bun run build
```

### 使用IIS部署（推荐Windows）

1. **启用IIS功能**
   - 控制面板 → 程序 → 启用或关闭Windows功能
   - 勾选"Internet Information Services"

2. **安装Python扩展**
   - 下载并安装HttpPlatformHandler
   - 配置web.config

3. **部署配置**
```xml
<?xml version="1.0" encoding="utf-8"?>
<configuration>
  <system.webServer>
    <handlers>
      <add name="httpPlatformHandler" path="*" verb="*" modules="httpPlatformHandler" resourceType="Unspecified" />
    </handlers>
    <httpPlatform processPath=".\venv\Scripts\python.exe" arguments=".\manage.py runserver 127.0.0.1:8000" stdoutLogEnabled="true" stdoutLogFile=".\python.log" startupTimeLimit="20" requestTimeout="00:04:00" />
  </system.webServer>
</configuration>
```

## Docker部署（推荐）

### 1. 安装Docker Desktop
[下载地址](https://www.docker.com/products/docker-desktop/)

### 2. 使用Docker Compose

```powershell
# 在项目根目录
docker-compose up -d
```

## 一键启动脚本

创建 `start.bat` 文件：

```batch
@echo off
echo 启动美妆代工厂网站...

echo.
echo 1. 启动后端服务...
cd backend
call .\venv\Scripts\activate.bat
start "Backend Server" cmd /k "python manage.py runserver 0.0.0.0:8000"

echo.
echo 2. 启动前端服务...
cd ..\frontend
start "Frontend Server" cmd /k "npm run dev"

echo.
echo 服务启动完成！
echo 前端地址: http://localhost:3000
echo 后端地址: http://localhost:8000
echo 管理后台: http://localhost:8000/admin
echo 管理员账号: admin / admin123
echo.
pause
```

创建 `stop.bat` 文件：

```batch
@echo off
echo 停止所有服务...
taskkill /f /im python.exe
taskkill /f /im node.exe
echo 服务已停止！
pause
```

## 访问地址

- **前端网站**: http://localhost:3000
- **后端API**: http://localhost:8000
- **管理后台**: http://localhost:8000/admin (admin/admin123)

## 故障排除

### 检查服务状态
```powershell
# 检查进程
Get-Process | Where-Object {$_.ProcessName -eq "python"}
Get-Process | Where-Object {$_.ProcessName -eq "node"}

# 检查端口
Get-NetTCPConnection -LocalPort 8000,3000
```

### 日志查看
```powershell
# Django日志
cd backend
python manage.py runserver --verbosity=2

# 前端日志
cd frontend
npm run dev -- --debug
```

### 清理重置
```powershell
# 清理Python缓存
cd backend
rmdir /s __pycache__
rmdir /s ..\frontend\node_modules

# 重新安装
pip install -r requirements.txt
cd ..\frontend
npm install
```

## 技术支持

如遇问题，请检查：
1. Python和Node.js版本是否符合要求
2. 防火墙是否阻止了端口访问
3. 虚拟环境是否正确激活
4. 依赖是否完整安装

---

**注意**: "WARNING: This is a development server" 是Django开发服务器的正常提示，不是错误信息。在生产环境中请使用Gunicorn或IIS部署。
