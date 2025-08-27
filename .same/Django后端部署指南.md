# 珠海优美官网后端 - Django阿里云部署指南

## 📋 后端部署概览

本指南将帮助您在阿里云Ubuntu 22.04服务器上部署珠海优美化妆品官网的Django后端API。

### 后端架构
- **后端框架**: Django 5.2.4
- **数据库**: PostgreSQL 15.13
- **Web服务器**: Nginx + Gunicorn
- **进程管理**: Supervisor
- **缓存**: Redis (可选)
- **文件存储**: 阿里云OSS (可选)

---

## 🛒 1. 服务器配置要求

### 1.1 推荐配置
```bash
# 阿里云ECS配置
- 实例规格: ecs.c6.large (2核4GB) 或更高
- 操作系统: Ubuntu 22.04 LTS
- 带宽: 5Mbps 或更高
- 存储: 60GB SSD 或更高
- 安全组: 开放 22, 80, 443, 8000 端口
```

### 1.2 数据库配置
```bash
# 如果使用RDS (推荐生产环境)
- 数据库类型: PostgreSQL 15
- 实例规格: 2核4GB 或更高
- 存储: 100GB SSD

# 或自建PostgreSQL (开发/测试环境)
- 与Web服务器同一台机器
```

---

## 🔧 2. 系统环境准备

### 2.1 更新系统和安装基础工具
```bash
# 连接服务器
ssh root@your-server-ip

# 更新系统
sudo apt update && sudo apt upgrade -y

# 安装基础工具
sudo apt install -y curl wget git unzip build-essential software-properties-common

# 创建部署用户
sudo adduser django
sudo usermod -aG sudo django
su - django
```

### 2.2 安装Python 3.11
```bash
# 添加Python PPA
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt update

# 安装Python 3.11
sudo apt install -y python3.11 python3.11-venv python3.11-dev python3.11-distutils

# 安装pip
curl https://bootstrap.pypa.io/get-pip.py | python3.11

# 设置Python别名
echo 'alias python=python3.11' >> ~/.bashrc
echo 'alias pip=pip3.11' >> ~/.bashrc
source ~/.bashrc

# 验证安装
python --version  # 应该显示 Python 3.11.x
pip --version
```

### 2.3 安装PostgreSQL
```bash
# 安装PostgreSQL
sudo apt install -y postgresql postgresql-contrib libpq-dev

# 启动并设置开机自启
sudo systemctl start postgresql
sudo systemctl enable postgresql

# 创建数据库和用户
sudo -u postgres psql

-- 在PostgreSQL命令行中执行：
CREATE DATABASE zhuhai_youmei;
CREATE USER youmei_user WITH PASSWORD 'your_strong_password_here';
ALTER ROLE youmei_user SET client_encoding TO 'utf8';
ALTER ROLE youmei_user SET default_transaction_isolation TO 'read committed';
ALTER ROLE youmei_user SET timezone TO 'UTC';
GRANT ALL PRIVILEGES ON DATABASE zhuhai_youmei TO youmei_user;
\q
```

### 2.4 安装Redis (可选缓存)
```bash
# 安装Redis
sudo apt install -y redis-server

# 启动并设置开机自启
sudo systemctl start redis-server
sudo systemctl enable redis-server

# 配置Redis
sudo nano /etc/redis/redis.conf
# 修改以下配置：
# bind 127.0.0.1
# requirepass your_redis_password

# 重启Redis
sudo systemctl restart redis-server
```

### 2.5 安装Nginx
```bash
# 安装Nginx
sudo apt install -y nginx

# 启动并设置开机自启
sudo systemctl start nginx
sudo systemctl enable nginx
```

---

## 📦 3. Django项目部署

### 3.1 创建项目目录
```bash
# 创建项目目录
sudo mkdir -p /var/www/zhuhai-youmei-backend
sudo chown -R django:django /var/www/zhuhai-youmei-backend
cd /var/www/zhuhai-youmei-backend
```

### 3.2 上传Django项目

#### 方法1: Git部署
```bash
# 克隆项目 (如果有Git仓库)
git clone https://github.com/your-username/zhuhai-youmei-backend.git .
```

#### 方法2: 创建Django项目结构
```bash
# 创建虚拟环境
python -m venv venv
source venv/bin/activate

# 安装Django和依赖
pip install django==5.2.4 psycopg2-binary gunicorn python-decouple redis celery

# 创建Django项目
django-admin startproject zhuhai_youmei .
cd zhuhai_youmei

# 创建应用
python manage.py startapp products
python manage.py startapp news
python manage.py startapp company
python manage.py startapp contact
```

### 3.3 Django项目配置

#### 创建环境配置文件
```bash
# 创建.env文件
nano /var/www/zhuhai-youmei-backend/.env
```

```env
# .env 文件内容
DEBUG=False
SECRET_KEY=your-very-long-and-random-secret-key-here
ALLOWED_HOSTS=your-domain.com,www.your-domain.com,your-server-ip

# 数据库配置
DB_NAME=zhuhai_youmei
DB_USER=youmei_user
DB_PASSWORD=your_strong_password_here
DB_HOST=localhost
DB_PORT=5432

# Redis配置 (如果使用)
REDIS_URL=redis://localhost:6379/0
REDIS_PASSWORD=your_redis_password

# 邮件配置
EMAIL_HOST=smtp.gmail.com
EMAIL_PORT=587
EMAIL_USE_TLS=True
EMAIL_HOST_USER=your-email@gmail.com
EMAIL_HOST_PASSWORD=your-email-app-password

# 阿里云OSS配置 (如果使用)
OSS_ACCESS_KEY_ID=your-oss-access-key
OSS_ACCESS_KEY_SECRET=your-oss-secret-key
OSS_BUCKET_NAME=your-bucket-name
OSS_ENDPOINT=https://oss-cn-hangzhou.aliyuncs.com
```

#### Django settings.py配置
```bash
nano /var/www/zhuhai-youmei-backend/zhuhai_youmei/settings.py
```

```python
import os
from decouple import config
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent

# 安全配置
SECRET_KEY = config('SECRET_KEY')
DEBUG = config('DEBUG', default=False, cast=bool)
ALLOWED_HOSTS = config('ALLOWED_HOSTS', default='').split(',')

# 应用配置
INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'rest_framework',
    'corsheaders',
    'products',
    'news',
    'company',
    'contact',
]

MIDDLEWARE = [
    'corsheaders.middleware.CorsMiddleware',
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

ROOT_URLCONF = 'zhuhai_youmei.urls'

# 数据库配置
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': config('DB_NAME'),
        'USER': config('DB_USER'),
        'PASSWORD': config('DB_PASSWORD'),
        'HOST': config('DB_HOST'),
        'PORT': config('DB_PORT'),
    }
}

# 国际化
LANGUAGE_CODE = 'zh-hans'
TIME_ZONE = 'Asia/Shanghai'
USE_I18N = True
USE_TZ = True

# 静态文件配置
STATIC_URL = '/static/'
STATIC_ROOT = os.path.join(BASE_DIR, 'staticfiles')
STATICFILES_DIRS = [
    os.path.join(BASE_DIR, 'static'),
]

# 媒体文件配置
MEDIA_URL = '/media/'
MEDIA_ROOT = os.path.join(BASE_DIR, 'media')

# REST Framework配置
REST_FRAMEWORK = {
    'DEFAULT_PAGINATION_CLASS': 'rest_framework.pagination.PageNumberPagination',
    'PAGE_SIZE': 20,
    'DEFAULT_FILTER_BACKENDS': [
        'django_filters.rest_framework.DjangoFilterBackend',
        'rest_framework.filters.SearchFilter',
        'rest_framework.filters.OrderingFilter',
    ],
}

# CORS配置
CORS_ALLOWED_ORIGINS = [
    "https://your-domain.com",
    "https://www.your-domain.com",
    "http://localhost:3000",  # 开发环境
]

# 缓存配置 (如果使用Redis)
CACHES = {
    'default': {
        'BACKEND': 'django_redis.cache.RedisCache',
        'LOCATION': config('REDIS_URL'),
        'OPTIONS': {
            'CLIENT_CLASS': 'django_redis.client.DefaultClient',
            'PASSWORD': config('REDIS_PASSWORD', default=''),
        }
    }
}

# 邮件配置
EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'
EMAIL_HOST = config('EMAIL_HOST')
EMAIL_PORT = config('EMAIL_PORT', cast=int)
EMAIL_USE_TLS = config('EMAIL_USE_TLS', cast=bool)
EMAIL_HOST_USER = config('EMAIL_HOST_USER')
EMAIL_HOST_PASSWORD = config('EMAIL_HOST_PASSWORD')

# 安全配置
SECURE_BROWSER_XSS_FILTER = True
SECURE_CONTENT_TYPE_NOSNIFF = True
X_FRAME_OPTIONS = 'DENY'
SECURE_HSTS_SECONDS = 31536000
SECURE_HSTS_INCLUDE_SUBDOMAINS = True
SECURE_HSTS_PRELOAD = True

# 生产环境安全配置
if not DEBUG:
    SECURE_SSL_REDIRECT = True
    SESSION_COOKIE_SECURE = True
    CSRF_COOKIE_SECURE = True
```

### 3.4 创建数据模型

#### 产品模型 (products/models.py)
```python
from django.db import models
from django.utils import timezone

class Category(models.Model):
    name = models.CharField(max_length=100, verbose_name='分类名称')
    description = models.TextField(blank=True, verbose_name='分类描述')
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        verbose_name = '产品分类'
        verbose_name_plural = '产品分类'

    def __str__(self):
        return self.name

class Product(models.Model):
    title = models.CharField(max_length=200, verbose_name='产品名称')
    category = models.ForeignKey(Category, on_delete=models.CASCADE, verbose_name='产品分类')
    description = models.TextField(verbose_name='产品描述')
    main_image = models.ImageField(upload_to='products/', verbose_name='主图片')
    images = models.JSONField(default=list, blank=True, verbose_name='产品图片')
    specifications = models.JSONField(default=dict, blank=True, verbose_name='产品规格')
    min_order_quantity = models.CharField(max_length=100, blank=True, verbose_name='起订量')
    production_time = models.CharField(max_length=100, blank=True, verbose_name='生产周期')
    is_featured = models.BooleanField(default=False, verbose_name='是否推荐')
    is_active = models.BooleanField(default=True, verbose_name='是否启用')
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        verbose_name = '产品'
        verbose_name_plural = '产品'
        ordering = ['-created_at']

    def __str__(self):
        return self.title
```

#### 新闻模型 (news/models.py)
```python
from django.db import models
from django.utils import timezone

class News(models.Model):
    CATEGORY_CHOICES = [
        ('company', '公司动态'),
        ('industry', '行业资讯'),
        ('product', '产品新闻'),
    ]

    title = models.CharField(max_length=200, verbose_name='新闻标题')
    category = models.CharField(max_length=20, choices=CATEGORY_CHOICES, verbose_name='新闻分类')
    summary = models.TextField(max_length=500, verbose_name='新闻摘要')
    content = models.TextField(verbose_name='新闻内容')
    featured_image = models.ImageField(upload_to='news/', verbose_name='特色图片')
    is_featured = models.BooleanField(default=False, verbose_name='是否推荐')
    is_published = models.BooleanField(default=True, verbose_name='是否发布')
    published_at = models.DateTimeField(default=timezone.now, verbose_name='发布时间')
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        verbose_name = '新闻'
        verbose_name_plural = '新闻'
        ordering = ['-published_at']

    def __str__(self):
        return self.title
```

### 3.5 创建API视图

#### 产品API (products/views.py)
```python
from rest_framework import viewsets, filters
from rest_framework.decorators import action
from rest_framework.response import Response
from django_filters.rest_framework import DjangoFilterBackend
from .models import Category, Product
from .serializers import CategorySerializer, ProductSerializer

class CategoryViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Category.objects.all()
    serializer_class = CategorySerializer

class ProductViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Product.objects.filter(is_active=True)
    serializer_class = ProductSerializer
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['category', 'is_featured']
    search_fields = ['title', 'description']
    ordering_fields = ['created_at', 'title']
    ordering = ['-created_at']

    @action(detail=False, methods=['get'])
    def featured(self, request):
        featured_products = self.get_queryset().filter(is_featured=True)[:6]
        serializer = self.get_serializer(featured_products, many=True)
        return Response(serializer.data)

    @action(detail=False, methods=['get'])
    def by_category(self, request):
        category_id = request.query_params.get('category_id')
        if category_id:
            products = self.get_queryset().filter(category_id=category_id)
            page = self.paginate_queryset(products)
            if page is not None:
                serializer = self.get_serializer(page, many=True)
                return self.get_paginated_response(serializer.data)
            serializer = self.get_serializer(products, many=True)
            return Response(serializer.data)
        return Response({'error': 'category_id is required'}, status=400)
```

### 3.6 数据库迁移和初始化
```bash
# 激活虚拟环境
source /var/www/zhuhai-youmei-backend/venv/bin/activate
cd /var/www/zhuhai-youmei-backend

# 创建迁移文件
python manage.py makemigrations

# 执行迁移
python manage.py migrate

# 创建超级用户
python manage.py createsuperuser

# 收集静态文件
python manage.py collectstatic --noinput

# 测试Django应用
python manage.py runserver 0.0.0.0:8000
```

---

## 🚀 4. Gunicorn配置

### 4.1 安装和配置Gunicorn
```bash
# 激活虚拟环境
source /var/www/zhuhai-youmei-backend/venv/bin/activate

# 安装Gunicorn
pip install gunicorn

# 创建Gunicorn配置文件
nano /var/www/zhuhai-youmei-backend/gunicorn.conf.py
```

```python
# gunicorn.conf.py
import multiprocessing

bind = "127.0.0.1:8000"
workers = multiprocessing.cpu_count() * 2 + 1
worker_class = "sync"
worker_connections = 1000
max_requests = 1000
max_requests_jitter = 100
timeout = 30
keepalive = 2
preload_app = True
daemon = False
user = "django"
group = "django"
tmp_upload_dir = None
errorlog = "/var/log/gunicorn/error.log"
accesslog = "/var/log/gunicorn/access.log"
loglevel = "info"
```

### 4.2 创建Gunicorn日志目录
```bash
sudo mkdir -p /var/log/gunicorn
sudo chown -R django:django /var/log/gunicorn
```

### 4.3 创建Gunicorn启动脚本
```bash
nano /var/www/zhuhai-youmei-backend/start_gunicorn.sh
```

```bash
#!/bin/bash
NAME="zhuhai_youmei"
DJANGODIR=/var/www/zhuhai-youmei-backend
SOCKFILE=/var/www/zhuhai-youmei-backend/run/gunicorn.sock
USER=django
GROUP=django
NUM_WORKERS=3
DJANGO_SETTINGS_MODULE=zhuhai_youmei.settings
DJANGO_WSGI_MODULE=zhuhai_youmei.wsgi

echo "Starting $NAME as `whoami`"

# 激活虚拟环境
cd $DJANGODIR
source venv/bin/activate
export DJANGO_SETTINGS_MODULE=$DJANGO_SETTINGS_MODULE
export PYTHONPATH=$DJANGODIR:$PYTHONPATH

# 创建run目录
RUNDIR=$(dirname $SOCKFILE)
test -d $RUNDIR || mkdir -p $RUNDIR

# 启动Django应用
exec gunicorn ${DJANGO_WSGI_MODULE}:application \
  --name $NAME \
  --workers $NUM_WORKERS \
  --user=$USER --group=$GROUP \
  --bind=unix:$SOCKFILE \
  --log-level=info \
  --log-file=-
```

```bash
chmod +x /var/www/zhuhai-youmei-backend/start_gunicorn.sh
```

---

## 🎛️ 5. Supervisor进程管理

### 5.1 安装Supervisor
```bash
sudo apt install -y supervisor
```

### 5.2 创建Supervisor配置
```bash
sudo nano /etc/supervisor/conf.d/zhuhai_youmei.conf
```

```ini
[program:zhuhai_youmei]
command = /var/www/zhuhai-youmei-backend/start_gunicorn.sh
user = django
stdout_logfile = /var/log/gunicorn/supervisor.log
redirect_stderr = true
environment=LANG=en_US.UTF-8,LC_ALL=en_US.UTF-8
```

### 5.3 启动Supervisor服务
```bash
# 重新读取配置
sudo supervisorctl reread

# 更新配置
sudo supervisorctl update

# 启动应用
sudo supervisorctl start zhuhai_youmei

# 查看状态
sudo supervisorctl status

# 查看日志
sudo supervisorctl tail -f zhuhai_youmei
```

---

## 🌐 6. Nginx配置

### 6.1 创建Nginx站点配置
```bash
sudo nano /etc/nginx/sites-available/zhuhai-youmei-api
```

```nginx
upstream django {
    server unix:///var/www/zhuhai-youmei-backend/run/gunicorn.sock;
}

server {
    listen 80;
    server_name api.your-domain.com;

    # 重定向到HTTPS
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name api.your-domain.com;

    charset utf-8;
    client_max_body_size 75M;

    # SSL配置（稍后配置证书）
    # ssl_certificate /etc/letsencrypt/live/api.your-domain.com/fullchain.pem;
    # ssl_certificate_key /etc/letsencrypt/live/api.your-domain.com/privkey.pem;

    # 安全headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Referrer-Policy "no-referrer-when-downgrade" always;

    # 静态文件
    location /static/ {
        alias /var/www/zhuhai-youmei-backend/staticfiles/;
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    # 媒体文件
    location /media/ {
        alias /var/www/zhuhai-youmei-backend/media/;
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    # API请求
    location / {
        include /etc/nginx/uwsgi_params;
        proxy_pass http://django;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # 压缩配置
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_types
        application/json
        application/javascript
        text/css
        text/plain
        text/xml;
}
```

### 6.2 启用站点配置
```bash
# 创建软链接
sudo ln -s /etc/nginx/sites-available/zhuhai-youmei-api /etc/nginx/sites-enabled/

# 测试配置
sudo nginx -t

# 重启Nginx
sudo systemctl restart nginx
```

---

## 🔒 7. SSL证书配置

### 7.1 为API域名申请证书
```bash
# 安装Certbot
sudo apt install -y certbot python3-certbot-nginx

# 申请SSL证书
sudo certbot --nginx -d api.your-domain.com

# 设置自动续期
sudo crontab -e
# 添加：0 2 1 * * /usr/bin/certbot renew --quiet && /usr/bin/systemctl reload nginx
```

---

## 📊 8. 数据库备份和恢复

### 8.1 创建备份脚本
```bash
nano /home/django/backup_db.sh
```

```bash
#!/bin/bash
BACKUP_DIR="/home/django/backups"
DATE=$(date +%Y%m%d_%H%M%S)
DB_NAME="zhuhai_youmei"

# 创建备份目录
mkdir -p $BACKUP_DIR

# 备份数据库
pg_dump -h localhost -U youmei_user -d $DB_NAME > $BACKUP_DIR/db_backup_$DATE.sql

# 删除7天前的备份
find $BACKUP_DIR -name "db_backup_*.sql" -mtime +7 -delete

echo "数据库备份完成: $BACKUP_DIR/db_backup_$DATE.sql"
```

```bash
chmod +x /home/django/backup_db.sh

# 设置定期备份
crontab -e
# 添加：0 2 * * * /home/django/backup_db.sh
```

### 8.2 数据恢复
```bash
# 恢复数据库
psql -h localhost -U youmei_user -d zhuhai_youmei < backup_file.sql
```

---

## 🔧 9. 部署自动化脚本

### 9.1 创建部署脚本
```bash
nano /home/django/deploy_backend.sh
```

```bash
#!/bin/bash

echo "🚀 开始部署Django后端..."

PROJECT_DIR="/var/www/zhuhai-youmei-backend"
VENV_DIR="$PROJECT_DIR/venv"

# 切换到项目目录
cd $PROJECT_DIR

# 拉取最新代码
echo "📦 更新代码..."
git pull origin main

# 激活虚拟环境
source $VENV_DIR/bin/activate

# 安装依赖
echo "📋 安装依赖..."
pip install -r requirements.txt

# 收集静态文件
echo "📁 收集静态文件..."
python manage.py collectstatic --noinput

# 数据库迁移
echo "🗄️ 执行数据库迁移..."
python manage.py migrate

# 重启Gunicorn
echo "🔄 重启服务..."
sudo supervisorctl restart zhuhai_youmei

# 重启Nginx
sudo systemctl reload nginx

echo "✅ 后端部署完成！"
echo "🌐 API地址: https://api.your-domain.com"
```

```bash
chmod +x /home/django/deploy_backend.sh
```

---

## 🛠️ 10. 常见问题解决

### 10.1 权限问题
```bash
# 修复项目权限
sudo chown -R django:django /var/www/zhuhai-youmei-backend
sudo chmod -R 755 /var/www/zhuhai-youmei-backend
```

### 10.2 数据库连接问题
```bash
# 检查PostgreSQL状态
sudo systemctl status postgresql

# 测试数据库连接
sudo -u postgres psql -c "\l"

# 重置数据库密码
sudo -u postgres psql
ALTER USER youmei_user PASSWORD 'new_password';
```

### 10.3 静态文件问题
```bash
# 重新收集静态文件
python manage.py collectstatic --clear --noinput

# 检查Nginx静态文件配置
sudo nginx -t
```

### 10.4 Gunicorn问题
```bash
# 检查Gunicorn进程
ps aux | grep gunicorn

# 重启服务
sudo supervisorctl restart zhuhai_youmei

# 查看日志
sudo supervisorctl tail -f zhuhai_youmei
tail -f /var/log/gunicorn/error.log
```

---

## 📋 11. 性能优化

### 11.1 数据库优化
```python
# settings.py 数据库连接池
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': config('DB_NAME'),
        'USER': config('DB_USER'),
        'PASSWORD': config('DB_PASSWORD'),
        'HOST': config('DB_HOST'),
        'PORT': config('DB_PORT'),
        'CONN_MAX_AGE': 600,
        'OPTIONS': {
            'MAX_CONNS': 20,
        }
    }
}
```

### 11.2 缓存优化
```python
# 使用Redis缓存
CACHES = {
    'default': {
        'BACKEND': 'django_redis.cache.RedisCache',
        'LOCATION': 'redis://127.0.0.1:6379/1',
        'OPTIONS': {
            'CLIENT_CLASS': 'django_redis.client.DefaultClient',
        }
    }
}

# 缓存中间件
MIDDLEWARE = [
    'django.middleware.cache.UpdateCacheMiddleware',
    # ... 其他中间件
    'django.middleware.cache.FetchFromCacheMiddleware',
]
```

---

## 📞 12. 监控和日志

### 12.1 系统监控
```bash
# 安装监控工具
sudo apt install -y htop iotop nethogs

# 查看系统资源
htop
df -h
free -h
```

### 12.2 应用监控
```bash
# Django应用日志
tail -f /var/log/gunicorn/error.log
tail -f /var/log/gunicorn/access.log

# Nginx日志
tail -f /var/log/nginx/error.log
tail -f /var/log/nginx/access.log

# PostgreSQL日志
sudo tail -f /var/log/postgresql/postgresql-15-main.log
```

---

## 🔐 13. 安全配置

### 13.1 防火墙设置
```bash
# 配置UFW
sudo ufw allow ssh
sudo ufw allow 'Nginx Full'
sudo ufw allow 5432  # PostgreSQL (仅限本地)
sudo ufw enable
```

### 13.2 数据库安全
```bash
# 修改PostgreSQL配置
sudo nano /etc/postgresql/15/main/pg_hba.conf
# 确保只允许本地连接

sudo nano /etc/postgresql/15/main/postgresql.conf
# listen_addresses = 'localhost'
```

---

**🎉 Django后端部署完成！**

后端API现在可以通过 `https://api.your-domain.com` 访问。

**主要功能API端点:**
- `GET /api/products/` - 产品列表
- `GET /api/products/{id}/` - 产品详情
- `GET /api/categories/` - 产品分类
- `GET /api/news/` - 新闻列表
- `POST /api/contact/` - 联系表单

记得在前端配置中更新API基础URL指向您的后端域名！
