# 安装 Node.js 及相关工具

Write-Host "安装 Node.js 及相关工具..." -ForegroundColor Green

# 检查并安装 fnm (Fast Node Manager)
if (-not (Get-Command fnm -ErrorAction SilentlyContinue)) {
    Write-Host "`n正在安装 fnm (Fast Node Manager)..." -ForegroundColor Cyan
    winget install --id Schniz.fnm --accept-source-agreements --accept-package-agreements

    # 刷新环境变量
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
} else {
    Write-Host "`nfnm 已安装，跳过" -ForegroundColor Gray
}

# 检查 fnm 是否可用
if (Get-Command fnm -ErrorAction SilentlyContinue) {
    # 安装最新 LTS 版本的 Node.js
    Write-Host "`n正在安装 Node.js LTS..." -ForegroundColor Cyan
    fnm install --lts
    fnm default lts-latest
    fnm use lts-latest

    Write-Host "Node.js LTS 安装完成" -ForegroundColor Green
} else {
    Write-Host "fnm 不可用，请重新打开终端后再运行此脚本" -ForegroundColor Yellow
    exit 1
}

# 刷新环境变量以使用 node/npm
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")

# 检查并安装 pnpm
if (-not (Get-Command pnpm -ErrorAction SilentlyContinue)) {
    Write-Host "`n正在安装 pnpm..." -ForegroundColor Cyan
    winget install --id pnpm.pnpm --accept-source-agreements --accept-package-agreements
} else {
    Write-Host "`npnpm 已安装，跳过" -ForegroundColor Gray
}

# 检查并安装 yarn
if (-not (Get-Command yarn -ErrorAction SilentlyContinue)) {
    Write-Host "`n正在安装 yarn..." -ForegroundColor Cyan
    if (Get-Command npm -ErrorAction SilentlyContinue) {
        npm install -g yarn
    } else {
        Write-Host "npm 不可用，跳过 yarn 安装" -ForegroundColor Yellow
    }
} else {
    Write-Host "`nyarn 已安装，跳过" -ForegroundColor Gray
}

Write-Host "`nNode.js 环境配置完成！" -ForegroundColor Green
Write-Host "已安装: fnm, Node.js LTS, pnpm, yarn" -ForegroundColor Yellow
Write-Host "请重新打开终端以使环境变量生效。" -ForegroundColor Yellow

# 显示 fnm 配置提示
Write-Host "`n提示: 请将以下内容添加到 PowerShell 配置文件中以启用 fnm:" -ForegroundColor Cyan
Write-Host '  fnm env --use-on-cd --shell power-shell | Out-String | Invoke-Expression' -ForegroundColor Gray
