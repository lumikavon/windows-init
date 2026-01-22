# 安装并更新 WSL (使用 WSL 2)

# 检查是否以管理员权限运行
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "需要管理员权限来安装 WSL" -ForegroundColor Red
    exit 1
}

Write-Host "正在安装 WSL..." -ForegroundColor Green

# 安装 WSL
wsl --install --no-distribution

# 更新 WSL 到最新版本
Write-Host "正在更新 WSL 到最新版本..." -ForegroundColor Green
wsl --update

# 设置默认版本为 WSL 2 (使用 Hyper-V 第二代)
Write-Host "设置默认版本为 WSL 2..." -ForegroundColor Green
wsl --set-default-version 2

# 创建 .wslconfig 配置文件
Write-Host "创建 WSL 配置文件..." -ForegroundColor Green
$wslConfig = @"
[wsl2]
memory=16GB
processors=8
networkingMode=mirrored
nestedVirtualization=true
vmIdleTimeout=-1
guiApplications=true
ipv6=false
dhcp=true
localhostforwarding=true
debugConsole=false

[experimental]
autoMemoryReclaim=gradual
hostAddressLoopback=true
dnsTunneling=true
autoProxy=true
sparseVhd=true
"@
$wslConfig | Out-File -FilePath "$env:USERPROFILE\.wslconfig" -Encoding UTF8

Write-Host "WSL 安装完成" -ForegroundColor Green
Write-Host "可能需要重启计算机以完成配置" -ForegroundColor Yellow

Write-Host "WSL 安装完成，需要重启计算机以完成配置" -ForegroundColor Yellow
$restart = Read-Host "是否立即重启? (y/n)"
if ($restart -eq "y") {
    Restart-Computer
}