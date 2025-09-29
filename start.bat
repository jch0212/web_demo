@echo off
echo 启动小说阅读器...

REM 检查Node.js是否安装
node --version >nul 2>&1
if errorlevel 1 (
    echo 错误: Node.js未安装，请先安装Node.js
    pause
    exit /b 1
)

REM 安装依赖
echo 安装依赖包...
npm install

REM 启动服务器
echo 启动服务器...
echo 访问地址: http://localhost:3000
echo 按 Ctrl+C 停止服务器
npm start
