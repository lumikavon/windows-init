# 安装 Ubuntu 24.04 (WSL) 并启用 systemd

Write-Host "正在安装 Ubuntu 24.04..." -ForegroundColor Green

# 安装 Ubuntu 24.04
wsl --install -d Ubuntu-24.04

# 配置 systemd
Write-Host "配置 systemd..." -ForegroundColor Green
wsl -d Ubuntu-24.04 -u root -- bash -c "echo '[boot]' > /etc/wsl.conf"
wsl -d Ubuntu-24.04 -u root -- bash -c "echo 'systemd=true' >> /etc/wsl.conf"

# 设置为默认 distro
Write-Host "设置 Ubuntu-24.04 为默认 distro..." -ForegroundColor Green
wsl --set-default Ubuntu-24.04

Write-Host "Ubuntu 24.04 安装完成，systemd 已启用" -ForegroundColor Green
Write-Host "请运行 'wsl --shutdown' 后重新启动 WSL 以应用 systemd 配置" -ForegroundColor Yellow
