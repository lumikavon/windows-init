# 安装 Node.js 及相关工具

Write-Host "安装 Node.js 及相关工具..." -ForegroundColor Green

# 检查 scoop 是否可用
if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host "scoop 未安装，请先运行 scoop action 安装 Scoop" -ForegroundColor Red
    exit 1
}

# 检查并安装 Node.js LTS
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host "`n正在安装 Node.js LTS..." -ForegroundColor Cyan
    scoop install nodejs-lts

    if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
        # 刷新环境变量
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
    }

    if (Get-Command node -ErrorAction SilentlyContinue) {
        Write-Host "Node.js LTS 安装完成" -ForegroundColor Green
        node --version
        npm --version
    } else {
        Write-Host "Node.js 安装失败，请重新打开终端后再运行此脚本" -ForegroundColor Yellow
        exit 1
    }
} else {
    Write-Host "`nNode.js 已安装，跳过" -ForegroundColor Gray
    node --version
}

# 刷新环境变量以使用 node/npm
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")

# 检查并安装 pnpm
if (-not (Get-Command pnpm -ErrorAction SilentlyContinue)) {
    Write-Host "`n正在安装 pnpm..." -ForegroundColor Cyan
    scoop install pnpm

    if (Get-Command pnpm -ErrorAction SilentlyContinue) {
        Write-Host "pnpm 安装完成" -ForegroundColor Green
    }
} else {
    Write-Host "`npnpm 已安装，跳过" -ForegroundColor Gray
}

# 检查并安装 yarn
if (-not (Get-Command yarn -ErrorAction SilentlyContinue)) {
    Write-Host "`n正在安装 yarn..." -ForegroundColor Cyan
    scoop install yarn

    if (Get-Command yarn -ErrorAction SilentlyContinue) {
        Write-Host "yarn 安装完成" -ForegroundColor Green
    }
} else {
    Write-Host "`nyarn 已安装，跳过" -ForegroundColor Gray
}

Write-Host "`nNode.js 环境配置完成！" -ForegroundColor Green
Write-Host "已安装: Node.js LTS, pnpm, yarn" -ForegroundColor Yellow
Write-Host "请重新打开终端以使环境变量生效。" -ForegroundColor Yellow


