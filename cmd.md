# Cài đặt LXD và SSH container bằng tay

## 1. Cài LXD
```bash
apt update && apt upgrade -y
apt install snapd ufw -y
snap install lxd
```

## 2. Khởi tạo LXD
```bash
lxd init --auto
```

## 3. Tạo container
```bash
lxc launch ubuntu:24.04 mycontainer
```

## 4. Cài SSH server
```bash
lxc exec mycontainer -- apt update
lxc exec mycontainer -- apt install openssh-server sudo -y
```

## 5. Tạo user và bật sudo
```bash
lxc exec mycontainer -- adduser alice
lxc exec mycontainer -- usermod -aG sudo alice
```

## 6. Bật password login
```bash
lxc exec mycontainer -- sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
lxc exec mycontainer -- sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
lxc exec mycontainer -- systemctl restart ssh
```

## 7. Mở port SSH ra ngoài
```bash
lxc config device add mycontainer sshport proxy listen=tcp:0.0.0.0:2222 connect=tcp:127.0.0.1:22
ufw allow 2222/tcp
```

## 8. Kết nối
- Host: IP public của VPS
- Port: 2222
- Username: alice
- Password: mật khẩu đã đặt
