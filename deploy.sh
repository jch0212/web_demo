#!/bin/bash

# 小说阅读器云服务器部署脚本
# 使用方法: ./deploy.sh

echo "开始部署小说阅读器..."

# 检查Docker是否安装
if ! command -v docker &> /dev/null; then
    echo "Docker未安装，正在安装..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    sudo usermod -aG docker $USER
    echo "Docker安装完成，请重新登录后再次运行此脚本"
    exit 1
fi

# 检查Docker Compose是否安装
if ! command -v docker-compose &> /dev/null; then
    echo "Docker Compose未安装，正在安装..."
    sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
fi

# 创建必要的目录
echo "创建必要目录..."
mkdir -p chapters
mkdir -p public/images

# 检查chapters文件夹是否有内容
if [ ! "$(ls -A chapters)" ]; then
    echo "警告: chapters文件夹为空，请添加txt文件后再启动应用"
    echo "创建示例文件..."
    cat > chapters/第1章.txt << EOF
这是第1章的内容。

在一个阳光明媚的早晨，主人公开始了他的冒险之旅。
EOF
    cat > chapters/第2章.txt << EOF
这是第2章的内容。

主人公继续他的旅程，遇到了新的挑战。
EOF
    echo "已创建示例章节文件"
fi

# 停止现有容器
echo "停止现有容器..."
docker-compose -f docker-compose.prod.yml down 2>/dev/null || true

# 构建并启动应用
echo "构建并启动应用..."
docker-compose -f docker-compose.prod.yml up -d --build

# 等待应用启动
echo "等待应用启动..."
sleep 10

# 检查应用状态
if docker-compose -f docker-compose.prod.yml ps | grep -q "Up"; then
    echo "✅ 应用部署成功！"
    echo "访问地址: http://your-server-ip:3000"
    echo ""
    echo "管理命令:"
    echo "  查看日志: docker-compose -f docker-compose.prod.yml logs -f"
    echo "  重启应用: docker-compose -f docker-compose.prod.yml restart"
    echo "  停止应用: docker-compose -f docker-compose.prod.yml down"
else
    echo "❌ 应用启动失败，请检查日志:"
    docker-compose -f docker-compose.prod.yml logs
fi