# 切换 Claude/Codex/Gemini API Key
# 用于快速切换不同服务的 API 密钥

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "API Key 切换工具" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# 显示菜单
Write-Host "请选择要配置的服务:" -ForegroundColor Yellow
Write-Host "  0) 所有服务 (Claude + Codex + Gemini) 使用同一个 Key" -ForegroundColor Cyan
Write-Host "  1) Claude (Anthropic)" -ForegroundColor Gray
Write-Host "  2) Codex (OpenAI)" -ForegroundColor Gray
Write-Host "  3) Gemini (Google)" -ForegroundColor Gray
Write-Host "  4) 查看当前配置" -ForegroundColor Gray
Write-Host "  5) 退出" -ForegroundColor Gray
Write-Host ""

$choice = Read-Host "请输入序号 (0-5)"

switch ($choice) {
    "0" {
        # 配置所有服务使用同一个 API Key
        Write-Host "`n配置所有服务使用同一个 API Key..." -ForegroundColor Cyan
        Write-Host "访问 https://api.aicodemirror.com 获取 API Key" -ForegroundColor Gray
        Write-Host ""

        $apiKey = Read-Host "请输入 API Key"

        if ([string]::IsNullOrWhiteSpace($apiKey)) {
            Write-Host "未输入 API Key，配置已取消" -ForegroundColor Yellow
            exit 1
        }

        Write-Host "`n正在配置所有服务..." -ForegroundColor Cyan

        # 配置 Claude
        Write-Host "  配置 Claude..." -ForegroundColor Gray
        [System.Environment]::SetEnvironmentVariable("ANTHROPIC_BASE_URL", "https://api.aicodemirror.com/api/claudecode", "User")
        [System.Environment]::SetEnvironmentVariable("ANTHROPIC_API_KEY", $apiKey, "User")
        [System.Environment]::SetEnvironmentVariable("ANTHROPIC_AUTH_TOKEN", $apiKey, "User")
        $env:ANTHROPIC_BASE_URL = "https://api.aicodemirror.com/api/claudecode"
        $env:ANTHROPIC_API_KEY = $apiKey
        $env:ANTHROPIC_AUTH_TOKEN = $apiKey

        # 配置 Codex
        Write-Host "  配置 Codex..." -ForegroundColor Gray

        # 设置用户环境变量
        Write-Host "`n正在设置环境变量..." -ForegroundColor Cyan
        [System.Environment]::SetEnvironmentVariable("OPENAI_BASE_URL", "https://api.aicodemirror.com/api/codex/backend-api/codex", "User")
        [System.Environment]::SetEnvironmentVariable("OPENAI_API_KEY", $apiKey, "User")
        
        $codexDir = "$env:USERPROFILE\.codex"
        $authPath = Join-Path $codexDir "auth.json"

        if (-not (Test-Path $codexDir)) {
            New-Item -ItemType Directory -Path $codexDir -Force | Out-Null
        }

        $authJson = @{
            OPENAI_API_KEY = $apiKey
        } | ConvertTo-Json

        $authJson | Out-File -FilePath $authPath -Encoding utf8 -NoNewline

        # 配置 Gemini
        Write-Host "  配置 Gemini..." -ForegroundColor Gray
        [System.Environment]::SetEnvironmentVariable("GOOGLE_GEMINI_BASE_URL", "https://api.aicodemirror.com/api/gemini", "User")
        [System.Environment]::SetEnvironmentVariable("GEMINI_API_KEY", $apiKey, "User")
        $env:GOOGLE_GEMINI_BASE_URL = "https://api.aicodemirror.com/api/gemini"
        $env:GEMINI_API_KEY = $apiKey

        Write-Host "`n所有服务配置完成！" -ForegroundColor Green
        Write-Host ""
        Write-Host "已设置以下配置:" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "Claude (Anthropic):" -ForegroundColor Cyan
        Write-Host "  ANTHROPIC_BASE_URL = https://api.aicodemirror.com/api/claudecode" -ForegroundColor Gray
        Write-Host "  ANTHROPIC_API_KEY = $apiKey" -ForegroundColor Gray
        Write-Host "  ANTHROPIC_AUTH_TOKEN = $apiKey" -ForegroundColor Gray
        Write-Host ""
        Write-Host "Codex (OpenAI):" -ForegroundColor Cyan
        Write-Host "  配置文件: $authPath" -ForegroundColor Gray
        Write-Host "  OPENAI_API_KEY = $apiKey" -ForegroundColor Gray
        Write-Host ""
        Write-Host "Gemini (Google):" -ForegroundColor Cyan
        Write-Host "  GOOGLE_GEMINI_BASE_URL = https://api.aicodemirror.com/api/gemini" -ForegroundColor Gray
        Write-Host "  GEMINI_API_KEY = $apiKey" -ForegroundColor Gray
        Write-Host ""
        Write-Host "请重新打开终端以使环境变量生效" -ForegroundColor Yellow
    }

    "1" {
        # 配置 Claude
        Write-Host "`n配置 Claude API Key..." -ForegroundColor Cyan
        Write-Host "访问 https://api.aicodemirror.com 获取 API Key" -ForegroundColor Gray
        Write-Host ""

        $apiKey = Read-Host "请输入 Claude API Key"

        if ([string]::IsNullOrWhiteSpace($apiKey)) {
            Write-Host "未输入 API Key，配置已取消" -ForegroundColor Yellow
            exit 1
        }

        # 设置用户环境变量
        Write-Host "`n正在设置环境变量..." -ForegroundColor Cyan
        [System.Environment]::SetEnvironmentVariable("ANTHROPIC_BASE_URL", "https://api.aicodemirror.com/api/claudecode", "User")
        [System.Environment]::SetEnvironmentVariable("ANTHROPIC_API_KEY", $apiKey, "User")
        [System.Environment]::SetEnvironmentVariable("ANTHROPIC_AUTH_TOKEN", $apiKey, "User")

        # 更新当前会话
        $env:ANTHROPIC_BASE_URL = "https://api.aicodemirror.com/api/claudecode"
        $env:ANTHROPIC_API_KEY = $apiKey
        $env:ANTHROPIC_AUTH_TOKEN = $apiKey

        Write-Host "环境变量已设置（用户级）" -ForegroundColor Green
        Write-Host ""
        Write-Host "已设置以下环境变量:" -ForegroundColor Yellow
        Write-Host "  ANTHROPIC_BASE_URL = https://api.aicodemirror.com/api/claudecode" -ForegroundColor Gray
        Write-Host "  ANTHROPIC_API_KEY = $apiKey" -ForegroundColor Gray
        Write-Host "  ANTHROPIC_AUTH_TOKEN = $apiKey" -ForegroundColor Gray
        Write-Host ""
        Write-Host "请重新打开终端以使环境变量生效" -ForegroundColor Yellow
    }

    "2" {
        # 配置 Codex
        Write-Host "`n配置 Codex API Key..." -ForegroundColor Cyan
        Write-Host "访问 https://api.aicodemirror.com 获取 API Key" -ForegroundColor Gray
        Write-Host ""

        $apiKey = Read-Host "请输入 Codex API Key"

        if ([string]::IsNullOrWhiteSpace($apiKey)) {
            Write-Host "未输入 API Key，配置已取消" -ForegroundColor Yellow
            exit 1
        }

        # 设置用户环境变量
        Write-Host "`n正在设置环境变量..." -ForegroundColor Cyan
        [System.Environment]::SetEnvironmentVariable("OPENAI_BASE_URL", "https://api.aicodemirror.com/api/codex/backend-api/codex", "User")
        [System.Environment]::SetEnvironmentVariable("OPENAI_API_KEY", $apiKey, "User")

        $codexDir = "$env:USERPROFILE\.codex"
        $authPath = Join-Path $codexDir "auth.json"

        # 检查目录是否存在
        if (-not (Test-Path $codexDir)) {
            Write-Host "`n.codex 目录不存在，正在创建..." -ForegroundColor Yellow
            New-Item -ItemType Directory -Path $codexDir -Force | Out-Null
        }

        # 创建或更新 auth.json
        Write-Host "`n正在更新 auth.json..." -ForegroundColor Cyan
        $authJson = @{
            OPENAI_API_KEY = $apiKey
        } | ConvertTo-Json

        $authJson | Out-File -FilePath $authPath -Encoding utf8 -NoNewline

        Write-Host "auth.json 已更新" -ForegroundColor Green
        Write-Host ""
        Write-Host "配置文件位置:" -ForegroundColor Yellow
        Write-Host "  $authPath" -ForegroundColor Gray
        Write-Host ""
        Write-Host "API Key 已设置为: $apiKey" -ForegroundColor Gray
        Write-Host ""
        Write-Host "请重新打开终端以使配置生效" -ForegroundColor Yellow
    }

    "3" {
        # 配置 Gemini
        Write-Host "`n配置 Gemini API Key..." -ForegroundColor Cyan
        Write-Host "访问 https://api.aicodemirror.com 获取 API Key" -ForegroundColor Gray
        Write-Host ""

        $apiKey = Read-Host "请输入 Gemini API Key"

        if ([string]::IsNullOrWhiteSpace($apiKey)) {
            Write-Host "未输入 API Key，配置已取消" -ForegroundColor Yellow
            exit 1
        }

        # 设置用户环境变量
        Write-Host "`n正在设置环境变量..." -ForegroundColor Cyan
        [System.Environment]::SetEnvironmentVariable("GOOGLE_GEMINI_BASE_URL", "https://api.aicodemirror.com/api/gemini", "User")
        [System.Environment]::SetEnvironmentVariable("GEMINI_API_KEY", $apiKey, "User")

        # 更新当前会话
        $env:GOOGLE_GEMINI_BASE_URL = "https://api.aicodemirror.com/api/gemini"
        $env:GEMINI_API_KEY = $apiKey

        Write-Host "环境变量已设置（用户级）" -ForegroundColor Green
        Write-Host ""
        Write-Host "已设置以下环境变量:" -ForegroundColor Yellow
        Write-Host "  GOOGLE_GEMINI_BASE_URL = https://api.aicodemirror.com/api/gemini" -ForegroundColor Gray
        Write-Host "  GEMINI_API_KEY = $apiKey" -ForegroundColor Gray
        Write-Host ""
        Write-Host "请重新打开终端以使环境变量生效" -ForegroundColor Yellow
    }

    "4" {
        # 查看当前配置
        Write-Host "`n当前配置:" -ForegroundColor Cyan
        Write-Host ""

        # Claude 配置
        Write-Host "Claude (Anthropic):" -ForegroundColor Yellow
        $claudeBaseUrl = [System.Environment]::GetEnvironmentVariable("ANTHROPIC_BASE_URL", "User")
        $claudeApiKey = [System.Environment]::GetEnvironmentVariable("ANTHROPIC_API_KEY", "User")
        $claudeAuthToken = [System.Environment]::GetEnvironmentVariable("ANTHROPIC_AUTH_TOKEN", "User")

        if ($claudeApiKey) {
            Write-Host "  ANTHROPIC_BASE_URL = $claudeBaseUrl" -ForegroundColor Gray
            Write-Host "  ANTHROPIC_API_KEY = $claudeApiKey" -ForegroundColor Gray
            Write-Host "  ANTHROPIC_AUTH_TOKEN = $claudeAuthToken" -ForegroundColor Gray
        } else {
            Write-Host "  未配置" -ForegroundColor Gray
        }
        Write-Host ""

        # Codex 配置
        Write-Host "Codex (OpenAI):" -ForegroundColor Yellow
        $codexAuthPath = "$env:USERPROFILE\.codex\auth.json"
        if (Test-Path $codexAuthPath) {
            try {
                $codexAuth = Get-Content $codexAuthPath -Raw | ConvertFrom-Json
                Write-Host "  配置文件: $codexAuthPath" -ForegroundColor Gray
                Write-Host "  OPENAI_API_KEY = $($codexAuth.OPENAI_API_KEY)" -ForegroundColor Gray
            } catch {
                Write-Host "  配置文件存在但无法读取" -ForegroundColor Red
            }
        } else {
            Write-Host "  未配置" -ForegroundColor Gray
        }
        Write-Host ""

        # Gemini 配置
        Write-Host "Gemini (Google):" -ForegroundColor Yellow
        $geminiBaseUrl = [System.Environment]::GetEnvironmentVariable("GOOGLE_GEMINI_BASE_URL", "User")
        $geminiApiKey = [System.Environment]::GetEnvironmentVariable("GEMINI_API_KEY", "User")

        if ($geminiApiKey) {
            Write-Host "  GOOGLE_GEMINI_BASE_URL = $geminiBaseUrl" -ForegroundColor Gray
            Write-Host "  GEMINI_API_KEY = $geminiApiKey" -ForegroundColor Gray
        } else {
            Write-Host "  未配置" -ForegroundColor Gray
        }
        Write-Host ""
    }

    "5" {
        Write-Host "退出" -ForegroundColor Yellow
        exit 0
    }

    default {
        Write-Host "无效选择: $choice" -ForegroundColor Red
        exit 1
    }
}

Write-Host ""
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "配置完成！" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""
