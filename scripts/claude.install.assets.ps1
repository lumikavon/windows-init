

$ScriptRoot = Split-Path -Parent $PSScriptRoot
$assetsDir = Join-Path $ScriptRoot "scripts\assets"
$cmdFile = Join-Path $assetsDir "switch.claude.key.cmd"
$ps1File = Join-Path $assetsDir "switch.claude.key.ps1"
$system32Dir = "$env:SystemRoot\System32"

# 检查是否以管理员身份运行
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if ((Test-Path $cmdFile) -and (Test-Path $ps1File)) {
    if ($isAdmin) {
        try {
            Write-Host "正在复制文件到 System32..." -ForegroundColor Cyan
            Copy-Item -Path $cmdFile -Destination $system32Dir -Force
            Copy-Item -Path $ps1File -Destination $system32Dir -Force
            Write-Host "API Key 切换工具已安装到系统目录" -ForegroundColor Green
            Write-Host "现在可以在任何位置运行 'switch.claude.key' 来切换 API Key" -ForegroundColor Yellow
        } catch {
            Write-Host "无法复制文件到 System32: $_" -ForegroundColor Red
            Write-Host "API Key 切换工具位于: $assetsDir" -ForegroundColor Yellow
        }
    } else {
        Write-Host "当前未以管理员身份运行，无法复制到 System32" -ForegroundColor Yellow
        Write-Host "API Key 切换工具位于: $assetsDir" -ForegroundColor Gray
        Write-Host "如需全局访问，请以管理员身份重新运行此脚本" -ForegroundColor Gray
    }
} else {
    Write-Host "未找到 API Key 切换工具文件" -ForegroundColor Yellow
    if (-not (Test-Path $cmdFile)) {
        Write-Host "  缺失: $cmdFile" -ForegroundColor Gray
    }
    if (-not (Test-Path $ps1File)) {
        Write-Host "  缺失: $ps1File" -ForegroundColor Gray
    }
}