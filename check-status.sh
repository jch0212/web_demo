#!/bin/bash

# 检查应用状态脚本
echo "=== 检查小说阅读器应用状态 ==="

# 检查容器状态
echo "1. 容器状态:"
docker ps | grep novel-reader-app || echo "容器未运行"

# 检查容器日志
echo -e "\n2. 应用日志 (最近20行):"
docker logs novel-reader-app --tail=20 2>/dev/null || echo "无法获取日志"

# 检查端口占用
echo -e "\n3. 端口占用情况:"
netstat -tlnp | grep :3000 || echo "端口3000未被占用"

# 测试API
echo -e "\n4. API测试:"
curl -s http://localhost:3000/api/novel | head -c 200 || echo "API测试失败"

# 检查章节文件
echo -e "\n5. 章节文件:"
ls -la chapters/ | head -5

# 检查容器资源使用
echo -e "\n6. 容器资源使用:"
docker stats novel-reader-app --no-stream 2>/dev/null || echo "无法获取资源使用情况"

echo -e "\n=== 检查完成 ==="
echo "如果一切正常，您可以访问: http://your-server-ip:3000"
