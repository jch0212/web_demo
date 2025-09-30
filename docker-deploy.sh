#!/bin/bash

# Docker Compose 部署脚本
echo "=== 小说阅读器 Docker Compose 部署 ==="

# 检查Docker和Docker Compose是否安装
if ! command -v docker &> /dev/null; then
    echo "❌ Docker未安装，请先安装Docker"
    exit 1
fi

# 检查Docker Compose（新版本使用 docker compose）
if ! docker compose version &> /dev/null; then
    echo "❌ Docker Compose未安装，请先安装Docker Compose"
    exit 1
fi

# 检查项目文件
if [ ! -f "docker-compose.yml" ]; then
    echo "❌ 未找到docker-compose.yml文件"
    exit 1
fi

# 创建必要目录
echo "=== 创建必要目录 ==="
mkdir -p chapters public/images

# 检查章节文件
echo "=== 检查章节文件 ==="
if [ ! -d "chapters" ] || [ -z "$(ls -A chapters 2>/dev/null)" ]; then
    echo "⚠️  警告：chapters目录为空，请添加章节txt文件"
    echo "   章节文件应放在 chapters/ 目录中"
fi

# 停止现有容器
echo "=== 停止现有容器 ==="
docker compose down 2>/dev/null || true

# 清理旧镜像（可选）
echo "=== 清理Docker缓存 ==="
docker system prune -f

# 构建并启动服务
echo "=== 构建并启动服务 ==="
docker compose up -d --build

# 等待服务启动
echo "=== 等待服务启动 ==="
sleep 20

# 检查服务状态
echo "=== 检查服务状态 ==="
if docker compose ps | grep -q "Up"; then
    echo "✅ 服务启动成功"
    
    # 获取服务器IP
    SERVER_IP=$(curl -s ifconfig.me 2>/dev/null || echo "localhost")
    
    echo ""
    echo "🎉 部署完成！"
    echo "访问地址: http://$SERVER_IP:3000"
    echo "本地访问: http://localhost:3000"
    echo ""
    echo "管理命令:"
    echo "  查看状态: docker compose ps"
    echo "  查看日志: docker compose logs -f"
    echo "  重启服务: docker compose restart"
    echo "  停止服务: docker compose down"
    echo "  更新服务: docker compose up -d --build"
    
else
    echo "❌ 服务启动失败"
    echo "查看日志:"
    docker compose logs
    exit 1
fi