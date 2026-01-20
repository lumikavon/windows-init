# 安装 Codex

Write-Host "安装 Codex..." -ForegroundColor Green

# 检查 npm 是否可用
if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
    Write-Host "npm 未安装，请先运行 node action 安装 Node.js" -ForegroundColor Red
    exit 1
}

# 安装 Codex
Write-Host "`n正在安装 Codex..." -ForegroundColor Cyan
npm install -g @openai/codex

if (-not (Get-Command codex -ErrorAction SilentlyContinue)) {
    # 刷新环境变量
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
}

# 验证安装
if (Get-Command codex -ErrorAction SilentlyContinue) {
    Write-Host "`nCodex 安装成功！" -ForegroundColor Green
    codex -V
} else {
    Write-Host "`nCodex 安装完成，请重新打开终端后验证" -ForegroundColor Yellow
}

# 配置 Codex
Write-Host "`n配置 Codex..." -ForegroundColor Cyan

$codexDir = "$env:USERPROFILE\.codex"

# 删除并重新创建 .codex 目录
if (Test-Path $codexDir) {
    Write-Host "删除已存在的 .codex 目录..." -ForegroundColor Gray
    Remove-Item -Path $codexDir -Recurse -Force
}

Write-Host "创建 .codex 目录..." -ForegroundColor Gray
New-Item -ItemType Directory -Path $codexDir -Force | Out-Null

# 配置 API Key
$apiKey = Read-Host "请输入你的 API 密钥 (留空跳过配置)"

if (-not [string]::IsNullOrWhiteSpace($apiKey)) {
    # 创建 auth.json
    $authJson = @{
        OPENAI_API_KEY = $apiKey
    } | ConvertTo-Json

    $authPath = Join-Path $codexDir "auth.json"
    $authJson | Out-File -FilePath $authPath -Encoding utf8
    Write-Host "已创建 auth.json" -ForegroundColor Green

    # 创建 config.toml
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
} else {
    Write-Host "跳过配置" -ForegroundColor Gray
    Write-Host "`n请手动创建以下配置文件:" -ForegroundColor Yellow
    Write-Host "  $codexDir\auth.json" -ForegroundColor Gray
    Write-Host "  $codexDir\config.toml" -ForegroundColor Gray
}

Write-Host "`nCodex 配置完成！" -ForegroundColor Green
Write-Host "请重新打开终端后运行 'codex' 开始使用" -ForegroundColor Yellow
