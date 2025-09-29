#!/bin/bash

# 更新应用脚本
echo "开始更新应用..."

# 停止并删除现有容器
echo "=== 停止现有容器 ==="
docker stop novel-reader-app 2>/dev/null || true
docker rm novel-reader-app 2>/dev/null || true

# 重新构建镜像
echo "=== 重新构建镜像 ==="
docker build -t novel-reader:latest .

# 启动新容器
echo "=== 启动新容器 ==="
docker run -d \
    --name novel-reader-app \
    --restart unless-stopped \
    -p 3000:3000 \
    -v $(pwd)/chapters:/app/chapters \
    -v $(pwd)/public/images:/app/public/images \
    -e NODE_ENV=production \
    -e PORT=3000 \
    novel-reader:latest

# 等待启动
echo "=== 等待应用启动 ==="
sleep 10

# 检查状态
echo "=== 检查应用状态 ==="
docker ps | grep novel-reader-app

# 测试API
echo "=== 测试API ==="
curl -s http://localhost:3000/api/novel | head -c 100

echo "更新完成！"
echo "访问地址: http://112.124.107.162:3000"
