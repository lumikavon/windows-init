# 安装 MCP 相关依赖

function Show-Step { param([string]$Message) Write-Host "`n==> $Message" -ForegroundColor Cyan }
function Log-Info { param([string]$Message) Write-Host "[INFO] $Message" -ForegroundColor Gray }
function Log-Warning { param([string]$Message) Write-Host "[WARN] $Message" -ForegroundColor Yellow }
function Log-Error { param([string]$Message) Write-Host "[ERROR] $Message" -ForegroundColor Red }
function Log-Success { param([string]$Message) Write-Host "[OK] $Message" -ForegroundColor Green }

function Install-Uvx {
    Show-Step "安装 uvx"

    if (Get-Command uvx -ErrorAction SilentlyContinue) {
        Log-Info "uvx 已存在，跳过安装"
        return
    }

    Log-Info "通过官方安装脚本安装 uv..."
    try {
        irm https://astral.sh/uv/install.ps1 | iex
        $env:Path = "$env:USERPROFILE\.local\bin;$env:Path"
        Log-Success "uvx 安装完成"
    } catch {
        Log-Error "uvx 安装失败: $_"
        exit 1
    }
}

function Install-MCP {
    Show-Step "安装 MCP 相关依赖"

    if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
        Log-Error "未检测到 npm，请先安装 Node.js 环境"
        exit 1
    }

    $npmRegistry = "https://registry.npmmirror.com"
    $npmPkgs = @(
        "@playwright/mcp@latest"
        "@modelcontextprotocol/server-sequential-thinking"
        "@modelcontextprotocol/server-memory"
        "@modelcontextprotocol/server-filesystem"
        "@upstash/context7-mcp"
        "@agentdeskai/browser-tools-mcp@latest"
        "@anthropic-ai/claude-code-mcp-server"
    )

    Log-Info "通过 npm 安装 MCP 相关包..."
    foreach ($pkg in $npmPkgs) {
        Log-Info "安装 npm 包: $pkg"
        npm install -g $pkg --registry=$npmRegistry 2>$null
        if ($LASTEXITCODE -ne 0) { Log-Warning "安装失败: $pkg" }
    }

    # pipx 安装
    if (-not (Get-Command pipx -ErrorAction SilentlyContinue)) {
        Log-Info "未检测到 pipx，尝试通过 pip 安装..."
        if (Get-Command pip -ErrorAction SilentlyContinue) {
            pip install --user pipx 2>$null
            $env:Path = "$env:USERPROFILE\.local\bin;$env:Path"
        }
    }

    if (Get-Command pipx -ErrorAction SilentlyContinue) {
        $pipPkgs = @("mcp-server-time", "mcp-server-fetch")
        foreach ($pkg in $pipPkgs) {
            Log-Info "安装 pipx 包: $pkg"
            pipx install --force $pkg 2>$null
            if ($LASTEXITCODE -ne 0) { Log-Warning "安装失败: $pkg" }
        }
    } else {
        Log-Warning "pipx 未安装，跳过 Python MCP 包安装"
    }

    Log-Success "MCP 依赖安装完成"
}

function Configure-CodexMCP {
    Show-Step "配置 Codex MCP Servers"

    if (-not (Get-Command codex -ErrorAction SilentlyContinue)) {
        Log-Warning "未找到 codex 命令，跳过 MCP 配置"
        return
    }

    if (Get-Command uvx -ErrorAction SilentlyContinue) {
        codex mcp add fetch -- uvx mcp-server-fetch 2>$null
    }

    if (Get-Command npx -ErrorAction SilentlyContinue) {
        codex mcp add context7 -- npx -y @upstash/context7-mcp 2>$null
        codex mcp add sequential-thinking -- npx -y @modelcontextprotocol/server-sequential-thinking 2>$null
        codex mcp add playwright -- npx -y @playwright/mcp@latest 2>$null
    }

    Log-Success "Codex MCP Servers 配置完成"
}

function Configure-ClaudeMCP {
    Show-Step "配置 Claude MCP Servers"

    if (-not (Get-Command claude -ErrorAction SilentlyContinue)) {
        Log-Warning "未找到 claude 命令，跳过 MCP 配置"
        return
    }

    if (Get-Command uvx -ErrorAction SilentlyContinue) {
        claude mcp add --scope user fetch -- uvx mcp-server-fetch 2>$null
    }

    if (Get-Command npx -ErrorAction SilentlyContinue) {
        claude mcp add --scope user context7 -- npx -y @upstash/context7-mcp 2>$null
        claude mcp add --scope user sequential-thinking -- npx -y @modelcontextprotocol/server-sequential-thinking 2>$null
        claude mcp add --scope user playwright -- npx -y @playwright/mcp@latest 2>$null
    }

    Log-Success "Claude MCP Servers 配置完成"
}

function Configure-GeminiMCP {
    Show-Step "配置 Gemini MCP Servers"

    if (-not (Get-Command gemini -ErrorAction SilentlyContinue)) {
        Log-Warning "未找到 gemini 命令，跳过 MCP 配置"
        return
    }

    if (Get-Command uvx -ErrorAction SilentlyContinue) {
        gemini mcp add fetch uvx mcp-server-fetch 2>$null
    }

    if (Get-Command npx -ErrorAction SilentlyContinue) {
        gemini mcp add context7 npx -y @upstash/context7-mcp 2>$null
        gemini mcp add sequential-thinking npx -y @modelcontextprotocol/server-sequential-thinking 2>$null
        gemini mcp add playwright npx -y @playwright/mcp@latest 2>$null
        gemini mcp add chrome-devtools npx -y chrome-devtools-mcp@latest 2>$null
    }

    Log-Success "Gemini MCP Servers 配置完成"
}

# 主流程
Install-Uvx
Install-MCP
Configure-CodexMCP
Configure-ClaudeMCP
Configure-GeminiMCP

Write-Host "`nMCP 安装和配置完成！" -ForegroundColor Green
