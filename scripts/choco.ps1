# 安装 Chocolatey 包管理器

# 检查是否已安装
if (Get-Command choco -ErrorAction SilentlyContinue) {
    Write-Host "Chocolatey 已安装，跳过" -ForegroundColor Gray
    exit 0
}

Write-Host "正在安装 Chocolatey..." -ForegroundColor Cyan

# 设置执行策略并安装 Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

if (Get-Command choco -ErrorAction SilentlyContinue) {
    Write-Host "Chocolatey 安装完成！" -ForegroundColor Green
} else {
    Write-Host "Chocolatey 安装失败，请检查网络连接" -ForegroundColor Red
    exit 1
}
