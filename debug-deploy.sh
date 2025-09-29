#!/bin/bash

# 调试版本部署脚本
echo "开始调试部署..."

# 检查系统信息
echo "=== 系统信息 ==="
uname -a
echo "内存信息:"
free -h
echo "磁盘信息:"
df -h

# 检查Docker状态
echo "=== Docker状态 ==="
docker --version
docker-compose --version
docker system df

# 停止现有容器
echo "=== 停止现有容器 ==="
docker-compose -f docker-compose.prod.yml down 2>/dev/null || true

# 清理Docker缓存
echo "=== 清理Docker缓存 ==="
docker system prune -f

# 创建必要目录
echo "=== 创建目录 ==="
mkdir -p chapters
mkdir -p public/images

# 检查chapters目录
echo "=== 检查chapters目录 ==="
ls -la chapters/ || echo "chapters目录为空"

# 构建镜像（显示详细输出）
echo "=== 构建镜像 ==="
docker-compose -f docker-compose.prod.yml build --no-cache --progress=plain

# 启动应用
echo "=== 启动应用 ==="
docker-compose -f docker-compose.prod.yml up -d

# 等待启动
echo "=== 等待应用启动 ==="
sleep 15

# 检查容器状态
echo "=== 容器状态 ==="
docker-compose -f docker-compose.prod.yml ps

# 检查日志
echo "=== 应用日志 ==="
docker-compose -f docker-compose.prod.yml logs --tail=50

# 检查容器资源使用
echo "=== 容器资源使用 ==="
docker stats --no-stream

# 测试API
echo "=== 测试API ==="
curl -f http://localhost:3000/api/novel || echo "API测试失败"

echo "调试完成！"
