# 安装 Hyper-V

# 检查是否以管理员权限运行
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "需要管理员权限来安装 Hyper-V" -ForegroundColor Red
    exit 1
}

Write-Host "正在安装 Hyper-V..." -ForegroundColor Green

# 启用 Hyper-V 功能
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All -NoRestart

if ($LASTEXITCODE -eq 0 -or $?) {
    Write-Host "Hyper-V 安装完成，需要重启计算机以完成配置" -ForegroundColor Yellow
    $restart = Read-Host "是否立即重启? (y/n)"
    if ($restart -eq "y") {
        Restart-Computer
    }
} else {
    Write-Host "Hyper-V 安装失败" -ForegroundColor Red
    exit 1
}
