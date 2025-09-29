#!/bin/bash

# 使用Docker Compose V2的部署脚本
echo "开始使用Docker Compose V2部署..."

# 检查Docker Compose V2是否可用
if ! docker compose version >/dev/null 2>&1; then
    echo "Docker Compose V2不可用，请先运行: ./fix-docker-compose.sh"
    exit 1
fi

# 检查系统信息
echo "=== 系统信息 ==="
uname -a
echo "内存信息:"
free -h

# 检查Docker状态
echo "=== Docker状态 ==="
docker --version
docker compose version

# 停止现有容器
echo "=== 停止现有容器 ==="
docker compose -f docker-compose.prod.yml down 2>/dev/null || true

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

# 构建镜像
echo "=== 构建镜像 ==="
docker compose -f docker-compose.prod.yml build --no-cache

# 启动应用
echo "=== 启动应用 ==="
docker compose -f docker-compose.prod.yml up -d

# 等待启动
echo "=== 等待应用启动 ==="
sleep 15

# 检查容器状态
echo "=== 容器状态 ==="
docker compose -f docker-compose.prod.yml ps

# 检查日志
echo "=== 应用日志 ==="
docker compose -f docker-compose.prod.yml logs --tail=20

# 检查容器资源使用
echo "=== 容器资源使用 ==="
docker stats --no-stream

# 测试API
echo "=== 测试API ==="
curl -f http://localhost:3000/api/novel || echo "API测试失败"

echo "部署完成！"
echo "访问地址: http://your-server-ip:3000"
echo ""
echo "管理命令:"
echo "  查看日志: docker compose -f docker-compose.prod.yml logs -f"
echo "  重启应用: docker compose -f docker-compose.prod.yml restart"
echo "  停止应用: docker compose -f docker-compose.prod.yml down"
