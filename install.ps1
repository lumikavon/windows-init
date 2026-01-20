# 安装脚本 - 检查并安装缺失的基础工具
param(
    [string]$Action = ""
)

$ScriptRoot = $PSScriptRoot

# 检查 winget 是否可用
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "winget 未安装或不可用，请先安装 App Installer" -ForegroundColor Red
    exit 1
}

Write-Host "检查并安装缺失的基础工具..." -ForegroundColor Green


# 如果未提供 action，交互式选择
if ([string]::IsNullOrWhiteSpace($Action)) {
    Write-Host "请选择要执行的 action:" -ForegroundColor Cyan
    Write-Host "  1) base" -ForegroundColor Gray
    Write-Host "  2) choco" -ForegroundColor Gray
    Write-Host "  3) scoop" -ForegroundColor Gray
    Write-Host "  4) node" -ForegroundColor Gray
    Write-Host "  5) claude" -ForegroundColor Gray
    Write-Host "  6) codex" -ForegroundColor Gray
    Write-Host "  7) gemini" -ForegroundColor Gray
    Write-Host "  8) vscode" -ForegroundColor Gray
    Write-Host "  9) ssh" -ForegroundColor Gray
    $choice = Read-Host "请输入序号 (1-9)"
    switch ($choice) {
        "1" { $Action = "base" }
        "2" { $Action = "choco" }
        "3" { $Action = "scoop" }
        "4" { $Action = "node" }
        "5" { $Action = "claude" }
        "6" { $Action = "codex" }
        "7" { $Action = "gemini" }
        "8" { $Action = "vscode" }
        "9" { $Action = "ssh" }
        default {
            Write-Host "无效选择: $choice" -ForegroundColor Red
            exit 1
        }
    }
}

# 根据 action 执行不同脚本
switch ($Action) {
    "base" {
        & "$ScriptRoot\scripts\base.ps1"
        exit $LASTEXITCODE
    }
    "choco" {
        & gsudo pwsh -File "$ScriptRoot\scripts\choco.ps1"
        exit $LASTEXITCODE
    }
    "scoop" {
        & "$ScriptRoot\scripts\scoop.ps1"
        exit $LASTEXITCODE
    }
    "node" {
        & "$ScriptRoot\scripts\node.ps1"
        exit $LASTEXITCODE
    }
    "claude" {
        & "$ScriptRoot\scripts\claude.ps1"
        exit $LASTEXITCODE
    }
    "codex" {
        & "$ScriptRoot\scripts\codex.ps1"
        exit $LASTEXITCODE
    }
    "gemini" {
        & "$ScriptRoot\scripts\gemini.ps1"
        exit $LASTEXITCODE
    }
    "vscode" {
        & "$ScriptRoot\scripts\vscode.ps1"
        exit $LASTEXITCODE
    }
    "ssh" {
        & gsudo pwsh -File "$ScriptRoot\scripts\ssh.ps1"
        exit $LASTEXITCODE
    }
    default {
        Write-Host "未知的 action: $Action" -ForegroundColor Red
        Write-Host "可用的 action: base, choco, scoop, node, claude, codex, gemini, vscode, ssh" -ForegroundColor Yellow
        exit 1
    }
}