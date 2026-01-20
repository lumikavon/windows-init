# 安装基础软件 (gsudo, git, pwsh)

$installing = $false

# 检查并安装 gsudo
if (-not (Get-Command gsudo -ErrorAction SilentlyContinue)) {
    Write-Host "`n正在安装 gsudo..." -ForegroundColor Cyan
    winget install --id gerardog.gsudo --accept-source-agreements --accept-package-agreements
    $installing = $true
} else {
    Write-Host "`ngsudo 已安装，跳过" -ForegroundColor Gray
}

# 检查并安装 Git for Windows
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "`n正在安装 Git for Windows..." -ForegroundColor Cyan
    winget install --id Git.Git --accept-source-agreements --accept-package-agreements
    $installing = $true
} else {
    Write-Host "`nGit 已安装，跳过" -ForegroundColor Gray
}

# 检查并安装 PowerShell (PowerShell 7+)
if (-not (Get-Command pwsh -ErrorAction SilentlyContinue)) {
    Write-Host "`n正在安装 PowerShell..." -ForegroundColor Cyan
    winget install --id Microsoft.PowerShell --accept-source-agreements --accept-package-agreements
    $installing = $true
} else {
    Write-Host "`nPowerShell 已安装，跳过" -ForegroundColor Gray
}

if ($installing) {
    Write-Host "`n基础工具安装完成。" -ForegroundColor Green
    Write-Host "请重新打开终端以使环境变量生效。" -ForegroundColor Yellow
}
