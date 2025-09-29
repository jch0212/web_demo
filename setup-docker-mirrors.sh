#!/bin/bash

# 配置Docker国内镜像源
echo "开始配置Docker国内镜像源..."

# 检查Docker是否运行
if ! docker info >/dev/null 2>&1; then
    echo "Docker未运行，请先启动Docker"
    exit 1
fi

# 创建Docker配置目录
sudo mkdir -p /etc/docker

# 备份现有配置
if [ -f /etc/docker/daemon.json ]; then
    sudo cp /etc/docker/daemon.json /etc/docker/daemon.json.backup
    echo "已备份现有配置到 /etc/docker/daemon.json.backup"
fi

# 配置国内镜像源
sudo tee /etc/docker/daemon.json > /dev/null <<EOF
{
  "registry-mirrors": [
    "https://docker.mirrors.ustc.edu.cn",
    "https://hub-mirror.c.163.com",
    "https://mirror.baidubce.com"
  ],
  "insecure-registries": [],
  "debug": false,
  "experimental": false
}
EOF

echo "Docker镜像源配置完成！"

# 重启Docker服务
echo "正在重启Docker服务..."
sudo systemctl restart docker

# 等待Docker重启
sleep 5

# 验证配置
echo "验证Docker配置..."
docker info | grep -A 10 "Registry Mirrors"

echo "配置完成！现在可以使用国内镜像源了。"
echo "运行部署脚本: ./china-deploy.sh"
