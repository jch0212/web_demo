#!/bin/bash

# 修复docker-compose段错误问题
echo "开始修复docker-compose问题..."

# 卸载现有的docker-compose
echo "=== 卸载现有docker-compose ==="
rm -f /usr/local/bin/docker-compose
rm -f /usr/bin/docker-compose

# 安装最新版本的docker-compose
echo "=== 安装最新版本docker-compose ==="
DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep -Po '"tag_name": "\K.*?(?=")')
echo "最新版本: $DOCKER_COMPOSE_VERSION"

# 下载并安装
curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# 创建软链接
ln -sf /usr/local/bin/docker-compose /usr/bin/docker-compose

# 验证安装
echo "=== 验证安装 ==="
docker-compose --version

# 如果还是有问题，尝试使用Docker Compose V2
echo "=== 尝试Docker Compose V2 ==="
docker compose version 2>/dev/null || echo "Docker Compose V2不可用"

echo "修复完成！"
echo "现在可以尝试重新运行部署脚本"
