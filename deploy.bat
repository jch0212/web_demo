@echo off
echo 开始部署小说阅读器...

REM 检查Docker是否安装
docker --version >nul 2>&1
if errorlevel 1 (
    echo 错误: Docker未安装，请先安装Docker
    pause
    exit /b 1
)

REM 检查Docker Compose是否安装
docker-compose --version >nul 2>&1
if errorlevel 1 (
    echo 错误: Docker Compose未安装，请先安装Docker Compose
    pause
    exit /b 1
)

REM 停止现有容器
echo 停止现有容器...
docker-compose down

REM 构建新镜像
echo 构建Docker镜像...
docker-compose build

REM 启动服务
echo 启动服务...
docker-compose up -d

REM 检查服务状态
echo 检查服务状态...
timeout /t 5 /nobreak >nul
docker-compose ps

echo 部署完成！
echo 访问地址: http://localhost:3000
echo 查看日志: docker-compose logs -f
pause
