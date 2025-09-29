# 小说阅读器

一个现代化的网页小说阅读器，支持封面展示、章节导航和翻页功能。

## 功能特性

- 📖 小说封面展示
- 📚 章节列表导航
- 🔄 翻页功能（上一章/下一章）
- 📱 响应式设计，支持移动端
- ⌨️ 键盘导航支持
- 🐳 Docker部署支持

## 快速开始

### 本地开发

1. 安装依赖：
```bash
npm install
```

2. 启动开发服务器：
```bash
npm run dev
```

3. 访问 http://localhost:3000

### Docker部署

1. 构建镜像：
```bash
docker build -t novel-reader .
```

2. 运行容器：
```bash
docker run -p 3000:3000 novel-reader
```

### 使用Docker Compose

```bash
docker-compose up -d
```

## 项目结构

```
├── public/                 # 静态文件
│   ├── index.html         # 主页面
│   ├── styles.css         # 样式文件
│   ├── script.js          # 前端脚本
│   └── images/            # 图片资源
├── server.js              # 后端服务器
├── package.json           # 项目配置
├── Dockerfile             # Docker配置
├── docker-compose.yml     # Docker Compose配置
└── README.md              # 说明文档
```

## 自定义小说内容

1. 修改 `server.js` 中的 `novelData` 对象
2. 添加封面图片到 `public/images/` 目录
3. 更新章节内容和标题

## 部署到云服务器

1. 将项目文件上传到服务器
2. 安装Docker和Docker Compose
3. 运行 `docker-compose up -d`
4. 配置反向代理（如Nginx）指向3000端口

## 技术栈

- 前端：HTML5, CSS3, JavaScript (ES6+)
- 后端：Node.js, Express
- 部署：Docker, Docker Compose
