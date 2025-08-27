FROM python:3.12-slim

WORKDIR /app

# 安装系统依赖
RUN apt-get update && apt-get install -y \
    postgresql-client \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# 复制依赖文件
COPY requirements.txt .

# 安装Python依赖
RUN pip install --no-cache-dir -r requirements.txt

# 复制应用代码
COPY . .

# 创建静态文件和媒体文件目录
RUN mkdir -p staticfiles media

# 暴露端口
EXPOSE 8000

# 启动命令（在docker-compose中覆盖）
CMD ["gunicorn", "cosmetics_msd.wsgi:application", "--bind", "0.0.0.0:8000", "--workers", "4"]
