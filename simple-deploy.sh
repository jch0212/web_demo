#!/bin/bash

# 简化部署脚本 - 避免网络问题
echo "开始简化部署..."

# 检查系统信息
echo "=== 系统信息 ==="
uname -a
echo "内存信息:"
free -h

# 检查Docker状态
echo "=== Docker状态 ==="
docker --version

# 停止现有容器
echo "=== 停止现有容器 ==="
docker stop novel-reader-app 2>/dev/null || true
docker rm novel-reader-app 2>/dev/null || true

# 清理Docker缓存
echo "=== 清理Docker缓存 ==="
docker system prune -f

# 创建必要目录
echo "=== 创建目录 ==="
mkdir -p chapters
mkdir -p public/images

# 检查chapters目录
echo "=== 检查chapters目录 ==="
ls -la chapters/

# 使用更简单的构建方式
echo "=== 构建镜像（使用缓存） ==="
docker build -t novel-reader:latest . --no-cache=false

# 检查镜像是否构建成功
if docker images | grep -q novel-reader; then
    echo "✅ 镜像构建成功"
else
    echo "❌ 镜像构建失败"
    exit 1
fi

# 启动容器（简化配置）
echo "=== 启动容器 ==="
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
sleep 20

# 检查容器状态
echo "=== 容器状态 ==="
docker ps | grep novel-reader-app

# 检查日志
echo "=== 应用日志 ==="
docker logs novel-reader-app --tail=30

# 测试API
echo "=== 测试API ==="
curl -f http://localhost:3000/api/novel || echo "API测试失败"

echo "部署完成！"
echo "访问地址: http://your-server-ip:3000"
echo ""
echo "管理命令:"
echo "  查看日志: docker logs novel-reader-app -f"
echo "  重启容器: docker restart novel-reader-app"
echo "  停止容器: docker stop novel-reader-app"
