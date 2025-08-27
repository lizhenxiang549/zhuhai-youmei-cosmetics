# ✅ Ubuntu 22.04 Root用户一键部署指南

## 🎉 问题完全解决！

**版本 2.0** - 针对root用户执行优化，完全解决权限和项目结构问题！

### 🔧 主要修复

1. **✅ Root用户执行** - 彻底解决权限问题
2. **✅ 项目结构修复** - 自动检测并使用现有Django项目 `cosmetics_msd`
3. **✅ 文件路径修复** - 不再出现"找不到py文件"错误
4. **✅ 自动文件复制** - 智能检测源代码位置并复制到部署目录

---

## 🚀 立即使用

### 准备工作

1. **下载最新脚本**
   ```bash
   # 方法1: 克隆整个仓库
   git clone https://github.com/lizhenxiang549/zhuhai-youmei-cosmetics.git
   cd zhuhai-youmei-cosmetics

   # 方法2: 直接下载脚本
   wget https://raw.githubusercontent.com/lizhenxiang549/zhuhai-youmei-cosmetics/main/.same/Ubuntu22.04一键部署脚本-修正版.sh
   ```

2. **切换到root用户**
   ```bash
   sudo su -
   # 或者直接使用sudo执行
   ```

### 执行部署

```bash
# 赋予执行权限
chmod +x .same/Ubuntu22.04一键部署脚本-修正版.sh

# 运行部署脚本（必须root用户）
./.same/Ubuntu22.04一键部署脚本-修正版.sh
```

---

## 📋 脚本运行流程

### 1. **自动检测源代码位置**
脚本会按以下顺序查找项目源代码：
- `/home/project/msd-style-cosmetics`
- `./msd-style-cosmetics`
- 当前目录（如果包含`backend/manage.py`）

### 2. **系统检查**
- ✅ Root权限验证
- ✅ Ubuntu 22.04版本检查
- ✅ 内存和磁盘空间检查

### 3. **配置收集**
脚本会询问以下信息：
- 🌐 **域名**（或使用IP地址）
- 📧 **管理员邮箱**
- 🔑 **数据库密码**（至少8位）
- 🔑 **Redis密码**（至少8位）
- 🔑 **Django管理员密码**（至少8位）

### 4. **自动安装组件**
- Node.js 20 + Bun包管理器
- Python 3.11 + pip
- PostgreSQL数据库
- Redis缓存
- Nginx反向代理
- Supervisor进程管理

### 5. **项目部署**
- 📁 **自动复制**项目文件到 `/var/www/zhuhai-youmei/ym-cosmetics/`
- 🐍 **Django后端**：使用现有的`cosmetics_msd`项目
- 🖼️ **Vue前端**：使用现有的前端项目结构
- 🔧 **配置服务**：Nginx、Supervisor、防火墙等

---

## 📊 部署后的项目结构

```
/var/www/zhuhai-youmei/ym-cosmetics/
├── backend/                    # Django后端
│   ├── cosmetics_msd/         # Django项目（使用现有结构）
│   ├── core/                  # Django应用
│   ├── manage.py              # Django管理文件
│   ├── venv/                  # Python虚拟环境
│   └── .env                   # 环境配置
├── frontend/                   # Vue前端
│   ├── src/                   # 源代码
│   ├── dist/                  # 构建输出
│   └── package.json           # 依赖配置
├── logs/                      # 日志文件
├── backups/                   # 备份目录
└── scripts/                   # 管理脚本
    ├── deploy.sh              # 更新部署
    ├── backup.sh              # 数据备份
    ├── status.sh              # 状态检查
    └── logs.sh                # 日志查看
```

---

## 🎯 部署成功验证

### 访问地址
- 🌐 **前端网站**: `https://your-domain.com`
- ⚙️ **管理后台**: `https://your-domain.com/admin/`
- 🔌 **API接口**: `https://your-domain.com/api/`

### 管理员账号
- **用户名**: `admin`
- **密码**: 您设置的Django管理员密码
- **邮箱**: 您的管理员邮箱

### 服务状态检查
```bash
# 查看所有服务状态
/var/www/zhuhai-youmei/ym-cosmetics/scripts/status.sh

# 查看后端服务
supervisorctl status zhuhai-youmei-backend

# 查看Nginx状态
systemctl status nginx

# 查看数据库状态
systemctl status postgresql
```

---

## 🛠️ 常用管理命令

### 服务管理
```bash
# 重启后端服务
supervisorctl restart zhuhai-youmei-backend

# 重启Nginx
systemctl restart nginx

# 重启PostgreSQL
systemctl restart postgresql

# 重启Redis
systemctl restart redis-server
```

### 日志查看
```bash
# 查看后端日志
tail -f /var/www/zhuhai-youmei/ym-cosmetics/logs/backend.log

# 查看Nginx错误日志
tail -f /var/log/nginx/error.log

# 使用脚本查看所有日志
/var/www/zhuhai-youmei/ym-cosmetics/scripts/logs.sh
```

### 项目更新
```bash
# 使用更新脚本
/var/www/zhuhai-youmei/ym-cosmetics/scripts/deploy.sh

# 手动更新后端
cd /var/www/zhuhai-youmei/ym-cosmetics/backend
source venv/bin/activate
pip install -r requirements.txt
python manage.py migrate
python manage.py collectstatic --noinput
supervisorctl restart zhuhai-youmei-backend
```

### 数据备份
```bash
# 使用备份脚本
/var/www/zhuhai-youmei/ym-cosmetics/scripts/backup.sh

# 手动备份数据库
pg_dump -h localhost -U www-data zhuhai_youmei > backup_$(date +%Y%m%d).sql
```

---

## 🔍 故障排除

### 常见问题

#### 1. 后端服务启动失败
```bash
# 查看错误日志
tail -f /var/www/zhuhai-youmei/ym-cosmetics/logs/backend_error.log

# 检查Django配置
cd /var/www/zhuhai-youmei/ym-cosmetics/backend
source venv/bin/activate
python manage.py check
```

#### 2. 前端无法访问
```bash
# 检查Nginx配置
nginx -t

# 重启Nginx
systemctl restart nginx

# 检查前端构建
ls -la /var/www/zhuhai-youmei/ym-cosmetics/frontend/dist/
```

#### 3. 数据库连接失败
```bash
# 检查数据库服务
systemctl status postgresql

# 测试数据库连接
sudo -u postgres psql -d zhuhai_youmei -c "SELECT 1;"

# 检查用户权限
sudo -u postgres psql -c "\du"
```

#### 4. SSL证书问题
```bash
# 重新申请证书
certbot --nginx -d your-domain.com --force-renewal

# 检查证书状态
certbot certificates
```

### 重新部署
如果遇到严重问题，可以重新运行部署脚本：
```bash
# 停止所有服务
supervisorctl stop zhuhai-youmei-backend
systemctl stop nginx

# 清理旧安装（可选）
rm -rf /var/www/zhuhai-youmei

# 重新运行部署脚本
./.same/Ubuntu22.04一键部署脚本-修正版.sh
```

---

## 🎯 版本 2.0 新特性

### ✅ 解决的问题
- **权限问题**：使用root用户执行，彻底解决`mkdir: Permission denied`错误
- **项目结构**：自动检测现有Django项目`cosmetics_msd`，不再创建新项目
- **文件路径**：智能复制源代码到部署目录，解决"找不到py文件"错误
- **Bun安装**：简化为root用户安装，避免用户家目录权限问题

### 🚀 新增功能
- **智能源代码检测**：自动找到项目源代码位置
- **完整文件复制**：将整个项目复制到部署目录
- **权限自动设置**：正确设置所有文件和目录权限
- **错误处理增强**：更详细的错误信息和故障排除建议

### 📈 性能优化
- **Bun包管理器**：更快的前端依赖安装（降级npm备选）
- **PostgreSQL数据库**：高性能数据库配置
- **Nginx优化**：Gzip压缩、缓存配置、安全头设置
- **Supervisor管理**：可靠的进程守护和重启

---

## 📞 技术支持

- **GitHub仓库**: https://github.com/lizhenxiang549/zhuhai-youmei-cosmetics
- **脚本位置**: `.same/Ubuntu22.04一键部署脚本-修正版.sh`
- **版本**: 2.0 (Root用户版)

### 获取帮助
```bash
# 查看脚本帮助
./.same/Ubuntu22.04一键部署脚本-修正版.sh --help

# 只检查系统环境
./.same/Ubuntu22.04一键部署脚本-修正版.sh check

# 只验证部署状态
./.same/Ubuntu22.04一键部署脚本-修正版.sh verify
```

---

🎊 **恭喜！现在您可以使用完全修复的Root用户部署脚本，一键部署珠海优美化妆品官网了！**

所有权限问题和项目结构问题都已彻底解决。脚本会自动检测您的项目文件，复制到正确位置，并完成完整的生产环境部署。
