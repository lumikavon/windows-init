# 安装并启用 SSH Server

Write-Host "安装并启用 SSH Server..." -ForegroundColor Green

# 检查是否以管理员权限运行
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "此脚本需要管理员权限，请以管理员身份运行" -ForegroundColor Red
    exit 1
}

# 检查 OpenSSH Server 是否已安装
$sshServer = Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH.Server*'

if ($sshServer.State -ne 'Installed') {
    Write-Host "`n正在安装 OpenSSH Server..." -ForegroundColor Cyan
    Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

    if ($?) {
        Write-Host "OpenSSH Server 安装成功" -ForegroundColor Green
    } else {
        Write-Host "OpenSSH Server 安装失败" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "`nOpenSSH Server 已安装，跳过" -ForegroundColor Gray
}

# 检查 OpenSSH Client 是否已安装
$sshClient = Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH.Client*'

if ($sshClient.State -ne 'Installed') {
    Write-Host "`n正在安装 OpenSSH Client..." -ForegroundColor Cyan
    Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0

    if ($?) {
        Write-Host "OpenSSH Client 安装成功" -ForegroundColor Green
    } else {
        Write-Host "OpenSSH Client 安装失败" -ForegroundColor Red
    }
} else {
    Write-Host "`nOpenSSH Client 已安装，跳过" -ForegroundColor Gray
}

# 启动 SSH Server 服务
Write-Host "`n配置 SSH Server 服务..." -ForegroundColor Cyan

# 启动服务
Start-Service sshd -ErrorAction SilentlyContinue

# 设置服务为自动启动
Set-Service -Name sshd -StartupType 'Automatic'

# 检查服务状态
$sshdService = Get-Service -Name sshd -ErrorAction SilentlyContinue
if ($sshdService.Status -eq 'Running') {
    Write-Host "SSH Server 服务已启动" -ForegroundColor Green
} else {
    Write-Host "正在启动 SSH Server 服务..." -ForegroundColor Cyan
    Start-Service sshd
}

# 配置防火墙规则
Write-Host "`n配置防火墙规则..." -ForegroundColor Cyan

$firewallRule = Get-NetFirewallRule -Name "OpenSSH-Server-In-TCP" -ErrorAction SilentlyContinue

if (-not $firewallRule) {
    New-NetFirewallRule -Name "OpenSSH-Server-In-TCP" -DisplayName "OpenSSH Server (sshd)" -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
    Write-Host "防火墙规则已创建" -ForegroundColor Green
} else {
    Write-Host "防火墙规则已存在" -ForegroundColor Gray
}

# 设置默认 Shell 为 PowerShell
Write-Host "`n设置默认 Shell..." -ForegroundColor Cyan

$pwshPath = (Get-Command pwsh -ErrorAction SilentlyContinue).Source
$powershellPath = (Get-Command powershell -ErrorAction SilentlyContinue).Source

if ($pwshPath) {
    # 使用 PowerShell 7 作为默认 Shell
    New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value $pwshPath -PropertyType String -Force | Out-Null
    Write-Host "默认 Shell 已设置为 PowerShell 7 (pwsh)" -ForegroundColor Green
} elseif ($powershellPath) {
    # 使用 Windows PowerShell 作为默认 Shell
    New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value $powershellPath -PropertyType String -Force | Out-Null
    Write-Host "默认 Shell 已设置为 Windows PowerShell" -ForegroundColor Green
}

Write-Host "`nSSH Server 配置完成！" -ForegroundColor Green
Write-Host "`n服务状态:" -ForegroundColor Cyan
Get-Service sshd | Format-Table -Property Name, Status, StartType -AutoSize

Write-Host "连接方式: ssh $env:USERNAME@<IP地址>" -ForegroundColor Yellow
