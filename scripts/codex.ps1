# 安装 OpenAI Codex CLI 并配置 aicodemirror

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
    } else {
        # 重新安装
        Write-Host "`n正在重新安装 OpenAI Codex CLI..." -ForegroundColor Cyan
        npm install -g @openai/codex
    }
} else {
    # 安装 Codex
    Write-Host "`n正在安装 OpenAI Codex CLI..." -ForegroundColor Cyan
    npm install -g @openai/codex
}

if (-not (Get-Command codex -ErrorAction SilentlyContinue)) {
    # 刷新环境变量
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
}

# 验证安装
if (-not (Get-Command codex -ErrorAction SilentlyContinue)) {
    Write-Host "`nCodex CLI 安装失败" -ForegroundColor Red
    Write-Host "请重新打开终端后检查" -ForegroundColor Yellow
    exit 1
}

Write-Host "`nCodex CLI 安装成功！" -ForegroundColor Green

# 配置 Codex
Write-Host "`n配置 Codex 使用 aicodemirror..." -ForegroundColor Cyan

$codexDir = "$env:USERPROFILE\.codex"

# 删除并重新创建 .codex 目录
if (Test-Path $codexDir) {
    Write-Host "删除已存在的 .codex 目录..." -ForegroundColor Gray
    Remove-Item -Path $codexDir -Recurse -Force
}

Write-Host "创建 .codex 目录..." -ForegroundColor Gray
New-Item -ItemType Directory -Path $codexDir -Force | Out-Null

# 配置 API Key
Write-Host "`n请输入你的 API 密钥:" -ForegroundColor Cyan
Write-Host "访问 https://api.aicodemirror.com 获取 API Key" -ForegroundColor Gray
$apiKey = Read-Host "API 密钥"

if ([string]::IsNullOrWhiteSpace($apiKey)) {
    Write-Host "`n未输入 API 密钥，配置已取消" -ForegroundColor Yellow
    Write-Host "请手动创建配置文件:" -ForegroundColor Yellow
    Write-Host "  $codexDir\auth.json" -ForegroundColor Gray
    Write-Host "  $codexDir\config.toml" -ForegroundColor Gray
    exit 1
}

# 创建 auth.json
Write-Host "`n创建 auth.json..." -ForegroundColor Cyan
$authJson = @{
    OPENAI_API_KEY = $apiKey
} | ConvertTo-Json

$authPath = Join-Path $codexDir "auth.json"
$authJson | Out-File -FilePath $authPath -Encoding utf8 -NoNewline
Write-Host "已创建 auth.json" -ForegroundColor Green

# 创建 config.toml
Write-Host "创建 config.toml..." -ForegroundColor Cyan
$configToml = @"
model_provider = "aicodemirror"
model = "gpt-5.2-codex"
model_reasoning_effort = "xhigh"
disable_response_storage = true
preferred_auth_method = "apikey"

[model_providers.aicodemirror]
name = "aicodemirror"
base_url = "https://api.aicodemirror.com/api/codex/backend-api/codex"
wire_api = "responses"
"@

$configPath = Join-Path $codexDir "config.toml"
$configToml | Out-File -FilePath $configPath -Encoding utf8
Write-Host "已创建 config.toml" -ForegroundColor Green

Write-Host "`n=====================================" -ForegroundColor Cyan
Write-Host "Codex 配置完成！" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "配置信息:" -ForegroundColor Yellow
Write-Host "  配置目录: $codexDir" -ForegroundColor Gray
Write-Host "  提供商: aicodemirror" -ForegroundColor Gray
Write-Host "  模型: gpt-5.2-codex" -ForegroundColor Gray
Write-Host ""
Write-Host "开始使用:" -ForegroundColor Yellow
Write-Host "  1. 重新打开终端" -ForegroundColor Gray
Write-Host "  2. 进入项目目录: cd your-project-folder" -ForegroundColor Gray
Write-Host "  3. 运行: codex" -ForegroundColor Gray
Write-Host ""
Write-Host "验证安装: codex -V" -ForegroundColor Cyan
Write-Host ""

