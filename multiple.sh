#!/bin/bash

# 显示头部信息
echo "=============================================="
echo "         M  U  L  T  I  G  R  O  W            "
echo "           T  E  S  T  N  E  T                "
echo "        =============================         "
echo "                  By Hien                     "
echo "                 X/推特：@Hienkkkk             "
echo "=============================================="
echo ""
echo "=============================================="
echo "     要检查节点的状态，您可以使用以下命令：    "
echo "=============================================="
echo ""
echo "1. 检查节点进程是否正在运行："
echo "   ps aux | grep multiple-node"
echo ""
echo "2. 或者，使用 pgrep 查找进程 ID："
echo "   pgrep -af multiple-node"
echo ""
echo "3. 如果您使用的是 systemd（作为服务），可以运行："
echo "   systemctl status multiple-node.service"
echo ""
echo "4. 要查看节点的日志，检查 output.log 文件："
echo "   tail -f output.log"
echo ""
echo "=============================================="
echo "  如果您需要进一步的帮助，随时可以提问！ "
echo "=============================================="
echo ""

# 检查命令是否成功执行
check_command() {
    if [ $? -ne 0 ]; then
        echo "命令执行失败: $1"
        exit 1
    fi
}

# 停止节点并清理旧文件的函数
clean_up() {
    echo "正在停止节点并清理进程..."
    
    # 停止所有与 multiple-node 相关的进程
    sudo pkill -f multiple-node
    check_command "停止 multiple-node 进程"

    # 等待几秒钟确保进程完全停止
    sleep 5

    echo "检查进程是否已停止..."
    if ps aux | grep -v grep | grep -q multiple-node; then
        echo "仍然存在多个 multiple-node 进程，尝试强制停止..."
        sudo pkill -9 -f multiple-node
        check_command "强制停止 multiple-node 进程"
    fi

    echo "删除旧的安装文件..."
    rm -rf multipleforlinux multipleforlinux.tar
    check_command "删除旧文件"

    echo "节点已停止，旧文件已删除。"
}

# 获取并校验用户输入
get_user_input() {



    # 将输入的带宽和存储乘以1000
    BANDWIDTH_DOWNLOAD=200000
    BANDWIDTH_UPLOAD=200000
    STORAGE=200000
}

# 下载并安装节点
download_and_install_node() {


    echo "检查系统架构..."
    ARCH=$(uname -m)
    if [[ "$ARCH" == "x86_64" ]]; then
        CLIENT_URL="https://cdn.app.multiple.cc/client/linux/x64/multipleforlinux.tar"
    elif [[ "$ARCH" == "aarch64" ]]; then
        CLIENT_URL="https://cdn.app.multiple.cc/client/linux/arm64/multipleforlinux.tar"
    else
        echo "不支持的系统架构: $ARCH"
        exit 1
    fi

    echo "正在从 $CLIENT_URL 下载客户端..."
    wget $CLIENT_URL -O multipleforlinux.tar
    check_command "下载客户端"

    echo "正在解压文件..."
    tar -xvf multipleforlinux.tar
    check_command "解压客户端"

    cd multipleforlinux

    echo "正在授予权限..."
    chmod +x ./multiple-cli ./multiple-node
    check_command "授予执行权限"

    echo "正在将目录添加到系统路径..."
    echo "PATH=\$PATH:$(pwd)" >> ~/.bash_profile
    source ~/.bash_profile

    echo "正在设置权限..."
    chmod -R 777 $(pwd)
}

# 启动节点并绑定账户
start_node_and_bind_account() {
    echo "正在启动 multiple-node..."
    nohup ./multiple-node > output.log 2>&1 &
    check_command "启动 multiple-node"

    echo "正在绑定账户，ID: $IDENTIFIER，PIN: $PIN..."
    multiple-cli bind --bandwidth-download 200000 --identifier U8C73H3T --pin 535152 --storage 20000 --bandwidth-upload 200000
    check_command "绑定账户"
}

# 询问用户是否要停止现有的节点并从头开始重新安装

 clean_up  # 停止节点并删除旧文件
 #get_user_input  # 获取用户输入
 download_and_install_node  # 下载并安装节点
 start_node_and_bind_account  # 启动节点并绑定账户

echo "安装成功完成！"
