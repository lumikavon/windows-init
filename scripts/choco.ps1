# 安装 Chocolatey 包管理器

# 检查是否已安装
if (Get-Command choco -ErrorAction SilentlyContinue) {
    Write-Host "Chocolatey 已安装，跳过" -ForegroundColor Gray
    exit 0
}

# 检查是否存在损坏的安装
$chocoPath = "C:\ProgramData\chocolatey"
if (Test-Path $chocoPath) {
    Write-Host "检测到现有的 Chocolatey 安装目录，但 choco 命令不可用" -ForegroundColor Yellow
    Write-Host "这可能是一个不完整或损坏的安装" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "请选择操作:" -ForegroundColor Cyan
    Write-Host "  1) 删除现有安装并重新安装 (推荐)" -ForegroundColor Gray
    Write-Host "  2) 取消" -ForegroundColor Gray
    $choice = Read-Host "请输入序号 (1-2)"

    if ($choice -eq "1") {
        Write-Host "正在删除现有安装..." -ForegroundColor Cyan
        Remove-Item -Path $chocoPath -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "已删除现有安装" -ForegroundColor Green
    } else {
        Write-Host "已取消安装" -ForegroundColor Yellow
        exit 1
    }
}

Write-Host "正在安装 Chocolatey..." -ForegroundColor Cyan

# 设置执行策略并安装 Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072

try {
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
} catch {
    Write-Host "下载或执行 Chocolatey 安装脚本失败" -ForegroundColor Red
    Write-Host "错误信息: $_" -ForegroundColor Red
    Write-Host "请检查网络连接或访问 https://chocolatey.org/install 手动安装" -ForegroundColor Yellow
    exit 1
}

# 刷新环境变量
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

if (Get-Command choco -ErrorAction SilentlyContinue) {
    Write-Host "Chocolatey 安装完成！" -ForegroundColor Green
} else {
    Write-Host "Chocolatey 安装失败" -ForegroundColor Red
    Write-Host "choco 命令仍然不可用，请尝试:" -ForegroundColor Yellow
    Write-Host "  1. 关闭当前 PowerShell 窗口并重新打开" -ForegroundColor Gray
    Write-Host "  2. 手动访问 https://chocolatey.org/install 查看安装指南" -ForegroundColor Gray
    exit 1
}
