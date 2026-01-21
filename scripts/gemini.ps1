# 安装 Gemini CLI

Write-Host "安装 Gemini CLI..." -ForegroundColor Green

# 检查 npm 是否可用
if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
    Write-Host "npm 未安装，请先运行 node action 安装 Node.js" -ForegroundColor Red
    exit 1
}

# 安装 Gemini CLI
Write-Host "`n正在安装 Gemini CLI..." -ForegroundColor Cyan
npm install -g @google/gemini-cli

if (-not (Get-Command gemini -ErrorAction SilentlyContinue)) {
    # 刷新环境变量
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
}

# 验证安装
if (Get-Command gemini -ErrorAction SilentlyContinue) {
    Write-Host "`nGemini CLI 安装成功！" -ForegroundColor Green
} else {
    Write-Host "`nGemini CLI 安装完成，请重新打开终端后验证" -ForegroundColor Yellow
}

# 配置环境变量
Write-Host "`n配置环境变量..." -ForegroundColor Cyan

$apiKey = Read-Host "请输入你的 API 密钥 (留空跳过配置)"

if (-not [string]::IsNullOrWhiteSpace($apiKey)) {
    # 设置环境变量
    [System.Environment]::SetEnvironmentVariable("GOOGLE_GEMINI_BASE_URL", "https://api.aicodemirror.com/api/gemini", "User")
    [System.Environment]::SetEnvironmentVariable("GEMINI_API_KEY", $apiKey, "User")
    Write-Host "环境变量已设置（用户级）" -ForegroundColor Green

    # 更新当前会话的环境变量
    $env:GOOGLE_GEMINI_BASE_URL = "https://api.aicodemirror.com/api/gemini"
    $env:GEMINI_API_KEY = $apiKey
} else {
    Write-Host "跳过环境变量配置" -ForegroundColor Gray
    Write-Host "`n请手动设置以下环境变量:" -ForegroundColor Yellow
    Write-Host "  GOOGLE_GEMINI_BASE_URL = https://api.aicodemirror.com/api/gemini" -ForegroundColor Gray
    Write-Host "  GEMINI_API_KEY = 你的密钥" -ForegroundColor Gray
}

Write-Host "`nGemini CLI 配置完成！" -ForegroundColor Green
Write-Host "请重新打开终端后运行 'gemini' 开始使用" -ForegroundColor Yellow

Write-Host "`n首次使用步骤:" -ForegroundColor Cyan
Write-Host "  1. 运行 gemini" -ForegroundColor Gray
Write-Host "  2. 选择 'Use Gemini API Key' 并按回车确认" -ForegroundColor Gray
Write-Host "  3. 输入 /settings，将 Preview Features 切换为 true" -ForegroundColor Gray
Write-Host "  4. 输入 /quit 退出后重新启动" -ForegroundColor Gray
Write-Host "  5. 输入 /model 切换为 Gemini 3 Pro 模型" -ForegroundColor Gray
