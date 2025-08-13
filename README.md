# LXD Container SSH Access

Script này giúp bạn:
- Cài LXD
- Tạo container Ubuntu
- Cài SSH server
- Bật login bằng mật khẩu
- Mở port SSH ra ngoài để kết nối bằng Termius hoặc PuTTY

## Yêu cầu
- VPS Ubuntu 24.04 hoặc tương tự
- Quyền root

## Cài đặt & Sử dụng

### 1. Tải script
```bash
wget https://example.com/lxd.sh -O lxd.sh
chmod +x lxd.sh
```

### 2. Chạy script
```bash
sudo ./lxd.sh
```

### 3. Nhập thông tin khi script yêu cầu:
- **Tên container** (vd: zmdev)
- **Username** (vd: alice)
- **Mật khẩu** (vd: 123456)
- **Port SSH bên ngoài** (vd: 2222)

### 4. Kết nối SSH
- Host: IP public của VPS
- Port: Port đã nhập
- Username: Username đã nhập
- Password: Mật khẩu đã đặt

## Xóa container
```bash
lxc stop <container_name> --force
lxc delete <container_name>
```
