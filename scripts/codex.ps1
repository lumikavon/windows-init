# 安装 OpenAI Codex CLI

Write-Host "安装 OpenAI Codex CLI..." -ForegroundColor Green

# 检查 npm 是否可用
if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
    Write-Host "npm 未安装，请先运行 node action 安装 Node.js" -ForegroundColor Red
    exit 1
}

# 检查是否已安装
if (Get-Command codex -ErrorAction SilentlyContinue) {
    Write-Host "Codex CLI 已安装" -ForegroundColor Gray
    $choice = Read-Host "是否重新安装? (y/N)"
    if ($choice -ne "y" -and $choice -ne "Y") {
        Write-Host "跳过安装" -ForegroundColor Yellow
        exit 0
    }
}

# 安装 Codex
Write-Host "`n正在安装 OpenAI Codex CLI..." -ForegroundColor Cyan
npm install -g @openai/codex

if (-not (Get-Command codex -ErrorAction SilentlyContinue)) {
    # 刷新环境变量
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
}

# 验证安装
if (Get-Command codex -ErrorAction SilentlyContinue) {
    Write-Host "`nCodex CLI 安装成功！" -ForegroundColor Green
} else {
    Write-Host "`nCodex CLI 安装失败" -ForegroundColor Red
    Write-Host "请重新打开终端后检查" -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "OpenAI Codex CLI 安装完成！" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "如何使用 Codex:" -ForegroundColor Yellow
Write-Host "  1. 运行命令: codex" -ForegroundColor Gray
Write-Host "  2. 选择 'Sign in with ChatGPT' 使用 ChatGPT 账户登录" -ForegroundColor Gray
Write-Host "     (推荐使用 Plus/Pro/Team/Enterprise 计划)" -ForegroundColor Gray
Write-Host ""
Write-Host "或者使用 OpenAI API Key:" -ForegroundColor Yellow
Write-Host "  1. 访问: https://platform.openai.com/api-keys" -ForegroundColor Gray
Write-Host "  2. 创建 API Key" -ForegroundColor Gray
Write-Host "  3. 运行 'codex' 并选择 API key 登录方式" -ForegroundColor Gray
Write-Host ""
Write-Host "文档: https://developers.openai.com/codex" -ForegroundColor Cyan
Write-Host ""
