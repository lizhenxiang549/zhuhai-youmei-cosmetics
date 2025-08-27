# 🚀 Windows 11 快速开始指南

## 📋 关于WARNING消息

看到这个消息是**正常的**：
```
WARNING: This is a development server. Do not use it in a production setting.
```

这只是Django的提醒，告诉你当前运行的是开发服务器，不是错误！

## ⚡ 一键启动（推荐）

### 方法1: 批处理文件（最简单）
```cmd
双击运行 start.bat
```

### 方法2: PowerShell（推荐）
```powershell
双击运行 start.ps1
```

## 🔧 手动启动

如果一键启动有问题，按以下步骤手动启动：

### 1. 检查环境
```cmd
双击运行 diagnose.bat
```

### 2. 启动后端
```cmd
cd backend
python -m venv venv
.\venv\Scripts\activate.bat
pip install -r requirements.txt
python manage.py migrate
python manage.py load_sample_data
python manage.py runserver 0.0.0.0:8000
```

### 3. 启动前端（新窗口）
```cmd
cd frontend
npm install
npm run dev
```

## 🌐 访问地址

启动成功后访问：

- **网站首页**: http://localhost:3000
- **管理后台**: http://localhost:8000/admin
- **账号密码**: admin / admin123

## 🛑 停止服务

```cmd
双击运行 stop.bat
```

或按 `Ctrl+C` 在命令行中停止

## ⚠️ 常见问题

### Python命令不识别
**解决**: 重新安装Python，勾选"Add Python to PATH"

### 端口被占用
**解决**: 运行 `stop.bat` 或重启电脑

### 执行策略错误
**解决**: 以管理员身份运行PowerShell，执行：
```powershell
Set-ExecutionPolicy RemoteSigned
```

### npm安装慢
**解决**: 使用国内镜像
```cmd
npm config set registry https://registry.npmmirror.com
```

### pip安装失败
**解决**: 使用可信源
```cmd
pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org -r requirements.txt
```

## 📁 文件说明

- `start.bat` - Windows批处理启动脚本
- `start.ps1` - PowerShell启动脚本（功能更强）
- `stop.bat` - 停止所有服务
- `diagnose.bat` - 环境问题诊断
- `README.md` - 详细部署文档

## 🆘 需要帮助？

1. 运行 `diagnose.bat` 检查环境
2. 查看 `README.md` 详细文档
3. 确保Python 3.11+ 和 Node.js 18+ 已正确安装

---

**💡 提示**: Django的WARNING消息不是错误，项目能正常运行就没问题！
