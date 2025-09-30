# Docker Compose 管理命令参考

## 🚀 快速部署

### 一键部署
```bash
# 给脚本执行权限
chmod +x docker-deploy.sh

# 运行部署脚本
./docker-deploy.sh
```

### 手动部署
```bash
# 启动服务
docker compose up -d --build

# 查看状态
docker compose ps
```

## 📋 常用管理命令

### 服务控制
```bash
# 启动服务
docker compose up -d

# 停止服务
docker compose down

# 重启服务
docker compose restart

# 重新构建并启动
docker compose up -d --build
```

### 查看状态和日志
```bash
# 查看服务状态
docker compose ps

# 查看实时日志
docker compose logs -f

# 查看最近日志
docker compose logs --tail=50

# 查看特定服务日志
docker compose logs novel-reader
```

### 进入容器
```bash
# 进入应用容器
docker compose exec novel-reader sh

# 查看容器内部文件
docker compose exec novel-reader ls -la /app
```

## 🔧 故障排除

### 服务无法启动
```bash
# 查看详细日志
docker compose logs

# 检查容器状态
docker compose ps -a

# 重新构建镜像
docker compose build --no-cache
```

### 端口冲突
```bash
# 检查端口占用
netstat -tlnp | grep :3000

# 修改端口（编辑docker-compose.yml）
# ports:
#   - "3001:3000"  # 改为3001端口
```

### 清理资源
```bash
# 停止并删除容器
docker compose down

# 删除镜像
docker rmi $(docker images -q novel-reader)

# 清理所有未使用的资源
docker system prune -a
```

## 📁 文件管理

### 章节文件
```bash
# 上传章节文件到服务器
scp chapters/*.txt root@your-server:/opt/novel-reader/chapters/

# 检查章节文件
ls -la chapters/
```

### 配置文件
```bash
# 编辑docker-compose.yml
nano docker-compose.yml

# 重新加载配置
docker compose down
docker compose up -d
```

## 🌐 访问和测试

### 本地测试
```bash
# 测试API
curl http://localhost:3000/api/novel

# 测试章节
curl http://localhost:3000/api/chapter/1
```

### 外网访问
```bash
# 获取服务器IP
curl ifconfig.me

# 访问地址
http://your-server-ip:3000
```

## 🔄 更新和维护

### 更新应用
```bash
# 拉取最新代码
git pull

# 重新构建并启动
docker compose up -d --build
```

### 备份数据
```bash
# 备份章节文件
tar -czf chapters-backup.tar.gz chapters/

# 备份整个项目
tar -czf novel-reader-backup.tar.gz .
```

### 监控资源
```bash
# 查看资源使用情况
docker stats

# 查看容器详细信息
docker compose ps --format "table {{.Name}}\t{{.Status}}\t{{.Ports}}"
```

## ⚠️ 注意事项

1. **章节文件**：确保 `chapters/` 目录中有 `.txt` 文件
2. **文件权限**：确保Docker有读取文件的权限
3. **端口冲突**：确保3000端口未被占用
4. **内存限制**：监控服务器内存使用情况
5. **定期备份**：定期备份章节文件

## 🆘 常见问题

### Q: 容器启动失败
```bash
# 查看详细错误信息
docker compose logs

# 检查配置文件语法
docker compose config
```

### Q: 章节不显示
```bash
# 检查章节文件
ls -la chapters/

# 检查文件权限
chmod -R 755 chapters/
```

### Q: 无法访问应用
```bash
# 检查防火墙
ufw status

# 开放端口
ufw allow 3000
```
