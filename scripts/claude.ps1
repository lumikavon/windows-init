# 安装 Claude Code

Write-Host "安装 Claude Code..." -ForegroundColor Green

# 检查 npm 是否可用
if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
    Write-Host "npm 未安装，请先运行 node action 安装 Node.js" -ForegroundColor Red
    exit 1
}

# 卸载已安装的 Claude Code（如果存在）
Write-Host "`n检查并卸载旧版本..." -ForegroundColor Cyan
npm uninstall -g @anthropic-ai/claude-code 2>$null

# 安装 Claude Code
Write-Host "`n正在安装 Claude Code..." -ForegroundColor Cyan
npm install -g @anthropic-ai/claude-code

if (-not (Get-Command claude -ErrorAction SilentlyContinue)) {
    # 刷新环境变量
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
}

# 验证安装
if (Get-Command claude -ErrorAction SilentlyContinue) {
    Write-Host "`nClaude Code 安装成功！" -ForegroundColor Green
    claude -v
} else {
    Write-Host "`nClaude Code 安装完成，请重新打开终端后验证" -ForegroundColor Yellow
}

# 配置环境变量
Write-Host "`n配置环境变量..." -ForegroundColor Cyan

$apiKey = Read-Host "请输入你的 API 密钥 (留空跳过配置)"

if (-not [string]::IsNullOrWhiteSpace($apiKey)) {
    # 设置系统环境变量 (需要管理员权限)
    $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

    if ($isAdmin) {
        [System.Environment]::SetEnvironmentVariable("ANTHROPIC_BASE_URL", "https://api.aicodemirror.com/api/claudecode", "Machine")
        [System.Environment]::SetEnvironmentVariable("ANTHROPIC_API_KEY", $apiKey, "Machine")
        [System.Environment]::SetEnvironmentVariable("ANTHROPIC_AUTH_TOKEN", $apiKey, "Machine")
        Write-Host "环境变量已设置（系统级）" -ForegroundColor Green
    } else {
        # 设置用户环境变量
        [System.Environment]::SetEnvironmentVariable("ANTHROPIC_BASE_URL", "https://api.aicodemirror.com/api/claudecode", "User")
        [System.Environment]::SetEnvironmentVariable("ANTHROPIC_API_KEY", $apiKey, "User")
        [System.Environment]::SetEnvironmentVariable("ANTHROPIC_AUTH_TOKEN", $apiKey, "User")
        Write-Host "环境变量已设置（用户级）" -ForegroundColor Green
    }

    # 更新当前会话的环境变量
    $env:ANTHROPIC_BASE_URL = "https://api.aicodemirror.com/api/claudecode"
    $env:ANTHROPIC_API_KEY = $apiKey
    $env:ANTHROPIC_AUTH_TOKEN = $apiKey
} else {
    Write-Host "跳过环境变量配置" -ForegroundColor Gray
    Write-Host "`n请手动设置以下环境变量:" -ForegroundColor Yellow
    Write-Host "  ANTHROPIC_BASE_URL = https://api.aicodemirror.com/api/claudecode" -ForegroundColor Gray
    Write-Host "  ANTHROPIC_API_KEY = 你的密钥" -ForegroundColor Gray
    Write-Host "  ANTHROPIC_AUTH_TOKEN = 你的密钥" -ForegroundColor Gray
}

Write-Host "`nClaude Code 配置完成！" -ForegroundColor Green
Write-Host "请重新打开终端后运行 'claude' 开始使用" -ForegroundColor Yellow

Write-Host "`n常见问题:" -ForegroundColor Cyan
Write-Host "  1. 若出现 'Unable to connect' 或 '401 Invalid token'，请检查环境变量配置" -ForegroundColor Gray
Write-Host "  2. 若配置后仍不生效，尝试删除 ~/.claude.json 文件后重新启动 claude" -ForegroundColor Gray
