# 云服务器部署指南

## 准备工作

1. 确保您的项目已上传到GitHub仓库
2. 准备一台云服务器（推荐配置：1核2G内存，20G硬盘）
3. 确保服务器已安装Docker和Docker Compose

## 部署步骤

### 1. 连接服务器并克隆项目

```bash
# 连接到您的云服务器
ssh root@your-server-ip

# 克隆项目
git clone https://github.com/your-username/your-repo-name.git
cd your-repo-name
```

### 2. 安装Docker和Docker Compose（如果未安装）

```bash
# Ubuntu/Debian系统
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# 安装Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

### 3. 配置章节文件

```bash
# 创建chapters文件夹
mkdir -p chapters

# 添加您的章节txt文件到chapters文件夹
# 例如：cp /path/to/your/chapters/*.txt chapters/
```

### 4. 启动应用

```bash
# 使用生产环境配置启动
docker-compose -f docker-compose.prod.yml up -d

# 查看运行状态
docker-compose -f docker-compose.prod.yml ps
```

### 5. 配置Nginx反向代理（可选）

```bash
# 安装Nginx
sudo apt update
sudo apt install nginx

# 复制配置文件
sudo cp nginx.conf /etc/nginx/sites-available/novel-reader
sudo ln -s /etc/nginx/sites-available/novel-reader /etc/nginx/sites-enabled/

# 修改配置文件中的域名
sudo nano /etc/nginx/sites-available/novel-reader

# 重启Nginx
sudo systemctl restart nginx
sudo systemctl enable nginx
```

### 6. 配置防火墙

```bash
# 开放必要端口
sudo ufw allow 22    # SSH
sudo ufw allow 80    # HTTP
sudo ufw allow 443   # HTTPS
sudo ufw enable
```

## 管理命令

### 查看日志
```bash
docker-compose -f docker-compose.prod.yml logs -f
```

### 重启应用
```bash
docker-compose -f docker-compose.prod.yml restart
```

### 停止应用
```bash
docker-compose -f docker-compose.prod.yml down
```

### 更新应用
```bash
# 拉取最新代码
git pull

# 重新构建并启动
docker-compose -f docker-compose.prod.yml up -d --build
```

## 文件结构说明

```
your-project/
├── chapters/          # 章节txt文件目录
│   ├── 第1章.txt
│   ├── 第2章.txt
│   └── ...
├── public/           # 静态文件
├── server.js         # 服务器代码
├── docker-compose.prod.yml  # 生产环境配置
└── Dockerfile        # Docker镜像配置
```

## 注意事项

1. 确保chapters文件夹中有txt文件，否则应用会显示空章节列表
2. 章节文件名建议使用数字前缀确保正确排序
3. 定期备份chapters文件夹中的内容
4. 监控服务器资源使用情况

## 故障排除

### 应用无法启动
```bash
# 查看详细日志
docker-compose -f docker-compose.prod.yml logs

# 检查端口占用
netstat -tlnp | grep :3000
```

### 章节不显示
- 检查chapters文件夹是否存在
- 确认文件夹中有.txt文件
- 检查文件权限

### 性能优化
- 使用SSD硬盘提升I/O性能
- 配置适当的Docker资源限制
- 考虑使用CDN加速静态资源
