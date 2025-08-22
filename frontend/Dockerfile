FROM node:18-alpine

WORKDIR /app

# 复制package文件
COPY package*.json ./

# 安装依赖
RUN npm install

# 复制应用代码
COPY . .

# 暴露端口
EXPOSE 3000

# 开发环境启动命令
CMD ["npm", "run", "dev", "--", "--host", "0.0.0.0"]
