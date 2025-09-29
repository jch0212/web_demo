#!/bin/bash

# 小说阅读器部署脚本

echo "开始部署小说阅读器..."

# 检查Docker是否安装
if ! command -v docker &> /dev/null; then
    echo "错误: Docker未安装，请先安装Docker"
    exit 1
fi

# 检查Docker Compose是否安装
if ! command -v docker-compose &> /dev/null; then
    echo "错误: Docker Compose未安装，请先安装Docker Compose"
    exit 1
fi

# 停止现有容器
echo "停止现有容器..."
docker-compose down

# 构建新镜像
echo "构建Docker镜像..."
docker-compose build

# 启动服务
echo "启动服务..."
docker-compose up -d

# 检查服务状态
echo "检查服务状态..."
sleep 5
docker-compose ps

echo "部署完成！"
echo "访问地址: http://localhost:3000"
echo "查看日志: docker-compose logs -f"
