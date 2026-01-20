# 安装 Chocolatey 包管理器

# 检查是否以管理员身份运行
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "警告: 当前未以管理员身份运行" -ForegroundColor Yellow
    Write-Host "安装 Chocolatey 需要管理员权限" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "请选择操作:" -ForegroundColor Cyan
    Write-Host "  1) 继续尝试安装 (可能失败)" -ForegroundColor Gray
    Write-Host "  2) 退出 (推荐以管理员身份重新运行)" -ForegroundColor Gray
    $adminChoice = Read-Host "请输入序号 (1-2)"

    if ($adminChoice -eq "2") {
        Write-Host "请右键点击 PowerShell 并选择 '以管理员身份运行'，然后重新执行此脚本" -ForegroundColor Yellow
        exit 1
    }

    Write-Host "将尝试继续..." -ForegroundColor Cyan
    Write-Host ""
}

# 检查是否已安装
$chocoAlreadyInstalled = $false
if (Get-Command choco -ErrorAction SilentlyContinue) {
    Write-Host "Chocolatey 已安装" -ForegroundColor Gray
    $chocoAlreadyInstalled = $true
}

# 如果已经正常安装，跳到代理配置
if ($chocoAlreadyInstalled) {
    # 跳转到代理配置部分
} else {
    # 检查是否存在损坏的安装
    $chocoPath = "C:\ProgramData\chocolatey"
    if (Test-Path $chocoPath) {
    Write-Host "检测到现有的 Chocolatey 安装目录，但 choco 命令不可用" -ForegroundColor Yellow
    Write-Host "这可能是一个不完整或损坏的安装" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "请选择操作:" -ForegroundColor Cyan
    Write-Host "  1) 删除现有安装并重新安装 (推荐)" -ForegroundColor Gray
    Write-Host "  2) 取消" -ForegroundColor Gray
    $choice = Read-Host "请输入序号 (1-2)"

        if ($choice -eq "1") {
            Write-Host "正在删除现有安装..." -ForegroundColor Cyan

            # 尝试删除目录
            try {
                # 先尝试正常删除
                Remove-Item -Path $chocoPath -Recurse -Force -ErrorAction Stop
                Write-Host "已删除现有安装" -ForegroundColor Green
            } catch {
                Write-Host "删除失败，可能需要管理员权限" -ForegroundColor Yellow
                Write-Host "错误信息: $_" -ForegroundColor Red

                # 尝试使用 cmd 强制删除
                Write-Host "尝试使用 cmd 强制删除..." -ForegroundColor Cyan
                $result = cmd /c "rmdir /s /q `"$chocoPath`" 2>&1"

                if (Test-Path $chocoPath) {
                    Write-Host "无法完全删除目录，请以管理员身份运行 PowerShell 并执行以下命令:" -ForegroundColor Red
                    Write-Host "  Remove-Item -Path '$chocoPath' -Recurse -Force" -ForegroundColor Yellow
                    Write-Host "然后重新运行此脚本" -ForegroundColor Yellow
                    exit 1
                } else {
                    Write-Host "已使用 cmd 删除现有安装" -ForegroundColor Green
                }
            }

            # 验证是否完全删除
            if (Test-Path $chocoPath) {
                Write-Host "警告: 目录仍然存在，可能有部分文件未被删除" -ForegroundColor Yellow
                Write-Host "将尝试继续安装..." -ForegroundColor Cyan
            }
        } else {
            Write-Host "已取消安装" -ForegroundColor Yellow
            exit 1
        }
    }

    Write-Host "正在安装 Chocolatey..." -ForegroundColor Cyan

    # 设置执行策略并安装 Chocolatey
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072

    try {
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    } catch {
        Write-Host "下载或执行 Chocolatey 安装脚本失败" -ForegroundColor Red
        Write-Host "错误信息: $_" -ForegroundColor Red
        Write-Host "请检查网络连接或访问 https://chocolatey.org/install 手动安装" -ForegroundColor Yellow
        exit 1
    }

    # 刷新环境变量
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

    if (Get-Command choco -ErrorAction SilentlyContinue) {
        Write-Host "Chocolatey 安装完成！" -ForegroundColor Green
    } else {
        Write-Host "Chocolatey 安装失败" -ForegroundColor Red
        Write-Host "choco 命令仍然不可用，请尝试:" -ForegroundColor Yellow
        Write-Host "  1. 关闭当前 PowerShell 窗口并重新打开" -ForegroundColor Gray
        Write-Host "  2. 手动访问 https://chocolatey.org/install 查看安装指南" -ForegroundColor Gray
        exit 1
    }
}

# 配置代理
Write-Host "`n是否需要配置代理?" -ForegroundColor Cyan

# 获取系统当前代理
$systemProxy = ""
try {
    $proxySettings = Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -ErrorAction SilentlyContinue
    if ($proxySettings.ProxyEnable -eq 1 -and $proxySettings.ProxyServer) {
        $systemProxy = $proxySettings.ProxyServer
        # 如果代理地址不包含协议，添加 http://
        if ($systemProxy -and $systemProxy -notmatch "^https?://") {
            $systemProxy = "http://$systemProxy"
        }
    }
} catch {
    # 忽略错误
}

if ($systemProxy) {
    Write-Host "检测到系统代理: $systemProxy" -ForegroundColor Gray
    Write-Host "  1) 使用系统代理" -ForegroundColor Gray
    Write-Host "  2) 手动输入代理" -ForegroundColor Gray
    Write-Host "  3) 不使用代理" -ForegroundColor Gray
    $proxyChoice = Read-Host "请输入序号 (1-3)"
} else {
    Write-Host "未检测到系统代理" -ForegroundColor Gray
    Write-Host "  1) 手动输入代理" -ForegroundColor Gray
    Write-Host "  2) 不使用代理" -ForegroundColor Gray
    $proxyChoice = Read-Host "请输入序号 (1-2)"
}

$finalProxy = ""

if ($systemProxy) {
    switch ($proxyChoice) {
        "1" {
            $finalProxy = $systemProxy
        }
        "2" {
            Write-Host "`n请输入代理地址 (格式: http://127.0.0.1:7890 或 http://username:password@host:port):" -ForegroundColor Cyan
            $finalProxy = Read-Host "代理地址"
        }
        "3" {
            Write-Host "跳过代理配置" -ForegroundColor Yellow
        }
        default {
            Write-Host "无效选择，跳过代理配置" -ForegroundColor Yellow
        }
    }
} else {
    switch ($proxyChoice) {
        "1" {
            Write-Host "`n请输入代理地址 (格式: http://127.0.0.1:7890 或 http://username:password@host:port):" -ForegroundColor Cyan
            $finalProxy = Read-Host "代理地址"
        }
        "2" {
            Write-Host "跳过代理配置" -ForegroundColor Yellow
        }
        default {
            Write-Host "无效选择，跳过代理配置" -ForegroundColor Yellow
        }
    }
}

if (-not [string]::IsNullOrWhiteSpace($finalProxy)) {
    Write-Host "`n正在配置 Chocolatey 代理..." -ForegroundColor Cyan
    try {
        choco config set proxy $finalProxy
        Write-Host "Chocolatey 代理配置完成！" -ForegroundColor Green
        Write-Host "已设置代理: $finalProxy" -ForegroundColor Gray
    } catch {
        Write-Host "代理配置失败: $_" -ForegroundColor Red
    }
}

Write-Host "`nChocolatey 配置完成！" -ForegroundColor Green
