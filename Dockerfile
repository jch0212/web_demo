# 使用官方Node.js镜像作为基础镜像
FROM node:18-alpine

# 安装必要的工具
RUN apk add --no-cache wget

# 设置工作目录
WORKDIR /app

# 复制package.json和package-lock.json（如果存在）
COPY package*.json ./

# 安装依赖
RUN npm install --production --no-optional

# 复制应用代码
COPY . .

# 创建必要的目录
RUN mkdir -p public/images chapters

# 设置权限
RUN chown -R node:node /app
USER node

# 暴露端口
EXPOSE 3000

# 设置环境变量
ENV NODE_ENV=production
ENV NODE_OPTIONS="--max-old-space-size=512"

# 启动应用
CMD ["npm", "start"]
