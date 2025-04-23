#!/bin/bash

# 设置 screen 名称
SCREEN_NAME="titan"

# 安装 unzip 和 screen（适用于 Debian/Ubuntu）
echo "🔧 安装 unzip 和 screen（如已安装会跳过）..."
sudo apt update
sudo apt install -y unzip screen

# 下载 agent 安装包
echo "📦 下载 Titan Agent 安装包..."
wget https://pcdn.titannet.io/test4/bin/agent-linux.zip -O agent-linux.zip || {
  echo "❌ 下载失败，请检查网络连接"
  exit 1
}

# 创建安装目录
echo "📂 创建安装目录 /opt/titanagent ..."
sudo mkdir -p /opt/titanagent

# 解压安装包
echo "📦 解压安装包到 /opt/titanagent ..."
sudo unzip -o agent-linux.zip -d /opt/titanagent || {
  echo "❌ 解压失败，请检查 unzip 是否安装成功"
  exit 1
}

# 启动 screen 会话并运行 agent
echo "🚀 启动 Titan Agent in screen '$SCREEN_NAME' ..."
screen -Sdm $SCREEN_NAME bash -c "cd /opt/titanagent && ./agent --working-dir=/opt/titanagent --server-url=https://test4-api.titannet.io --channel=vps --key=UeZC4KzbfZYx"

echo "✅ 启动完成！"
echo "🔍 查看运行状态：screen -r $SCREEN_NAME"
