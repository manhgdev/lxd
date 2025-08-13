#!/bin/bash
# Script cài LXD, tạo container, cài SSH server, bật password login, mở port ra ngoài

if [ "$EUID" -ne 0 ]; then
    echo "❌ Vui lòng chạy script với quyền root"
    exit
fi

echo "=== CÀI LXD MỚI NHẤT ==="
apt update && apt upgrade -y
apt install snapd ufw -y
snap install lxd

echo "=== KHỞI TẠO LXD ==="
lxd init --auto

echo "=== TẠO CONTAINER ==="
read -p "Nhập tên container (vd: zmdev): " CT_NAME
read -p "Nhập username bên trong container: " USER_NAME
read -p "Nhập mật khẩu cho user: " USER_PASS
read -p "Nhập port SSH bên ngoài (vd: 2222): " SSH_PORT

lxc launch ubuntu:24.04 "$CT_NAME"
sleep 10

echo "=== CÀI SSH SERVER TRONG CONTAINER ==="
lxc exec "$CT_NAME" -- apt update
lxc exec "$CT_NAME" -- apt install openssh-server sudo -y

echo "=== TẠO USER VÀ BẬT SUDO ==="
lxc exec "$CT_NAME" -- adduser --disabled-password --gecos "" "$USER_NAME"
lxc exec "$CT_NAME" -- bash -c "echo '$USER_NAME:$USER_PASS' | chpasswd"
lxc exec "$CT_NAME" -- usermod -aG sudo "$USER_NAME"

echo "=== BẬT PASSWORD LOGIN ==="
lxc exec "$CT_NAME" -- sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
lxc exec "$CT_NAME" -- sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
lxc exec "$CT_NAME" -- bash -c "grep -rl 'PasswordAuthentication no' /etc/ssh/sshd_config.d | xargs -r sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/'"
lxc exec "$CT_NAME" -- systemctl restart ssh

echo "=== MỞ PORT SSH RA NGOÀI ==="
lxc config device add "$CT_NAME" sshport proxy listen=tcp:0.0.0.0:$SSH_PORT connect=tcp:127.0.0.1:22
ufw allow "$SSH_PORT"/tcp

VPS_IP=$(curl -s ifconfig.me)
echo "✅ HOÀN TẤT!"
echo "Dùng Termius/Putty để kết nối:"
echo "Host: $VPS_IP"
echo "Port: $SSH_PORT"
echo "Username: $USER_NAME"
echo "Password: $USER_PASS"
