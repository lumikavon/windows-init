# 安装 Scoop 包管理器并配置

# 检查是否已安装 scoop
$scoopInstalled = Get-Command scoop -ErrorAction SilentlyContinue

if (-not $scoopInstalled) {
    Write-Host "正在安装 Scoop..." -ForegroundColor Cyan

    # 设置执行策略
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

    # 安装 Scoop
    Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression

    if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
        Write-Host "Scoop 安装失败，请检查网络连接" -ForegroundColor Red
        exit 1
    }

    Write-Host "Scoop 安装完成！" -ForegroundColor Green

    # 配置代理
    # 检测系统代理
    $systemProxy = $null
    try {
        $regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
        $proxyEnable = Get-ItemProperty -Path $regPath -Name ProxyEnable -ErrorAction SilentlyContinue
        if ($proxyEnable.ProxyEnable -eq 1) {
            $proxyServer = Get-ItemProperty -Path $regPath -Name ProxyServer -ErrorAction SilentlyContinue
            if ($proxyServer.ProxyServer) {
                $rawProxy = $proxyServer.ProxyServer
                # 处理分协议格式: http=127.0.0.1:7890;https=127.0.0.1:7890;ftp=...
                if ($rawProxy -match "=") {
                    # 尝试提取 http 或 https 代理
                    if ($rawProxy -match "https?=([^;]+)") {
                        $systemProxy = $Matches[1]
                    }
                } else {
                    # 简单格式: 127.0.0.1:7890
                    $systemProxy = $rawProxy
                }
                # scoop 会自动添加 http:// 前缀，所以这里移除已有的前缀
                if ($systemProxy) {
                    $systemProxy = $systemProxy -replace "^https?://", ""
                }
            }
        }
    } catch {
        # 忽略错误
    }

    Write-Host "`n是否需要配置代理?" -ForegroundColor Cyan
    if ($systemProxy) {
        Write-Host "  检测到系统代理: $systemProxy" -ForegroundColor Yellow
        Write-Host "  1) 使用系统代理" -ForegroundColor Gray
        Write-Host "  2) 手动输入代理地址" -ForegroundColor Gray
        Write-Host "  3) 否 (跳过)" -ForegroundColor Gray
        $proxyChoice = Read-Host "请输入序号 (1-3)"

        switch ($proxyChoice) {
            "1" {
                Write-Host "正在配置系统代理..." -ForegroundColor Cyan
                scoop config proxy $systemProxy
                Write-Host "代理配置完成！使用: $systemProxy" -ForegroundColor Green
            }
            "2" {
                Write-Host "`n请输入代理地址 (格式: 127.0.0.1:7890 或 [username:password@]host:port):" -ForegroundColor Cyan
                Write-Host "  注意: 无需添加 http:// 前缀" -ForegroundColor Gray
                $proxyUrl = Read-Host "代理地址"
                if (-not [string]::IsNullOrWhiteSpace($proxyUrl)) {
                    # 移除可能的 http:// 前缀
                    $proxyUrl = $proxyUrl -replace "^https?://", ""
                    Write-Host "正在配置代理..." -ForegroundColor Cyan
                    scoop config proxy $proxyUrl
                    Write-Host "代理配置完成！" -ForegroundColor Green
                } else {
                    Write-Host "未输入代理地址，跳过配置" -ForegroundColor Yellow
                }
            }
            default {
                Write-Host "跳过代理配置" -ForegroundColor Yellow
            }
        }
    } else {
        Write-Host "  未检测到系统代理" -ForegroundColor Gray
        Write-Host "  1) 手动输入代理地址" -ForegroundColor Gray
        Write-Host "  2) 否 (跳过)" -ForegroundColor Gray
        $proxyChoice = Read-Host "请输入序号 (1-2)"

        if ($proxyChoice -eq "1") {
            Write-Host "`n请输入代理地址 (格式: 127.0.0.1:7890 或 [username:password@]host:port):" -ForegroundColor Cyan
            Write-Host "  注意: 无需添加 http:// 前缀" -ForegroundColor Gray
            $proxyUrl = Read-Host "代理地址"
            if (-not [string]::IsNullOrWhiteSpace($proxyUrl)) {
                # 移除可能的 http:// 前缀
                $proxyUrl = $proxyUrl -replace "^https?://", ""
                Write-Host "正在配置代理..." -ForegroundColor Cyan
                scoop config proxy $proxyUrl
                Write-Host "代理配置完成！" -ForegroundColor Green
            } else {
                Write-Host "未输入代理地址，跳过配置" -ForegroundColor Yellow
            }
        } else {
            Write-Host "跳过代理配置" -ForegroundColor Yellow
        }
    }
} else {
    Write-Host "Scoop 已安装，跳过安装步骤" -ForegroundColor Gray

    # 检查是否需要配置或修改代理
    # 检测系统代理
    $systemProxy = $null
    try {
        $regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
        $proxyEnable = Get-ItemProperty -Path $regPath -Name ProxyEnable -ErrorAction SilentlyContinue
        if ($proxyEnable.ProxyEnable -eq 1) {
            $proxyServer = Get-ItemProperty -Path $regPath -Name ProxyServer -ErrorAction SilentlyContinue
            if ($proxyServer.ProxyServer) {
                $rawProxy = $proxyServer.ProxyServer
                # 处理分协议格式: http=127.0.0.1:7890;https=127.0.0.1:7890;ftp=...
                if ($rawProxy -match "=") {
                    # 尝试提取 http 或 https 代理
                    if ($rawProxy -match "https?=([^;]+)") {
                        $systemProxy = $Matches[1]
                    }
                } else {
                    # 简单格式: 127.0.0.1:7890
                    $systemProxy = $rawProxy
                }
                # scoop 会自动添加 http:// 前缀，所以这里移除已有的前缀
                if ($systemProxy) {
                    $systemProxy = $systemProxy -replace "^https?://", ""
                }
            }
        }
    } catch {
        # 忽略错误
    }

    Write-Host "`n是否需要配置或修改代理?" -ForegroundColor Cyan
    if ($systemProxy) {
        Write-Host "  检测到系统代理: $systemProxy" -ForegroundColor Yellow
        Write-Host "  1) 使用系统代理" -ForegroundColor Gray
        Write-Host "  2) 手动输入代理地址" -ForegroundColor Gray
        Write-Host "  3) 删除现有代理配置" -ForegroundColor Gray
        Write-Host "  4) 否 (跳过)" -ForegroundColor Gray
        $proxyChoice = Read-Host "请输入序号 (1-4)"

        switch ($proxyChoice) {
            "1" {
                Write-Host "正在配置系统代理..." -ForegroundColor Cyan
                scoop config proxy $systemProxy
                Write-Host "代理配置完成！使用: $systemProxy" -ForegroundColor Green
            }
            "2" {
                Write-Host "`n请输入代理地址 (格式: 127.0.0.1:7890 或 [username:password@]host:port):" -ForegroundColor Cyan
                Write-Host "  注意: 无需添加 http:// 前缀" -ForegroundColor Gray
                $proxyUrl = Read-Host "代理地址"
                if (-not [string]::IsNullOrWhiteSpace($proxyUrl)) {
                    # 移除可能的 http:// 前缀
                    $proxyUrl = $proxyUrl -replace "^https?://", ""
                    Write-Host "正在配置代理..." -ForegroundColor Cyan
                    scoop config proxy $proxyUrl
                    Write-Host "代理配置完成！" -ForegroundColor Green
                } else {
                    Write-Host "未输入代理地址，跳过配置" -ForegroundColor Yellow
                }
            }
            "3" {
                Write-Host "正在删除代理配置..." -ForegroundColor Cyan
                scoop config rm proxy
                Write-Host "代理配置已删除" -ForegroundColor Green
            }
            default {
                Write-Host "跳过代理配置" -ForegroundColor Yellow
            }
        }
    } else {
        Write-Host "  未检测到系统代理" -ForegroundColor Gray
        Write-Host "  1) 手动输入代理地址" -ForegroundColor Gray
        Write-Host "  2) 删除现有代理配置" -ForegroundColor Gray
        Write-Host "  3) 否 (跳过)" -ForegroundColor Gray
        $proxyChoice = Read-Host "请输入序号 (1-3)"

        switch ($proxyChoice) {
            "1" {
                Write-Host "`n请输入代理地址 (格式: 127.0.0.1:7890 或 [username:password@]host:port):" -ForegroundColor Cyan
                Write-Host "  注意: 无需添加 http:// 前缀" -ForegroundColor Gray
                $proxyUrl = Read-Host "代理地址"
                if (-not [string]::IsNullOrWhiteSpace($proxyUrl)) {
                    # 移除可能的 http:// 前缀
                    $proxyUrl = $proxyUrl -replace "^https?://", ""
                    Write-Host "正在配置代理..." -ForegroundColor Cyan
                    scoop config proxy $proxyUrl
                    Write-Host "代理配置完成！" -ForegroundColor Green
                } else {
                    Write-Host "未输入代理地址，跳过配置" -ForegroundColor Yellow
                }
            }
            "2" {
                Write-Host "正在删除代理配置..." -ForegroundColor Cyan
                scoop config rm proxy
                Write-Host "代理配置已删除" -ForegroundColor Green
            }
            default {
                Write-Host "跳过代理配置" -ForegroundColor Yellow
            }
        }
    }
}

# 安装 git (scoop 需要 git 来添加 bucket)
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "`n正在安装 git..." -ForegroundColor Cyan
    scoop install git
}

# 添加额外的 bucket
$buckets = @("extras", "scoopet", "java", "versions", "dorado", "nerd-fonts")

Write-Host "`n正在添加额外的 bucket..." -ForegroundColor Cyan

# 获取已添加的 bucket
$existingBuckets = scoop bucket list | ForEach-Object { $_.Name }

foreach ($bucket in $buckets) {
    if ($existingBuckets -contains $bucket) {
        Write-Host "  $bucket 已存在，跳过" -ForegroundColor Gray
    } else {
        Write-Host "  正在添加 $bucket..." -ForegroundColor Cyan
        switch ($bucket) {
            "scoopet" {
                scoop bucket add scoopet https://github.com/ivaquero/scoopet
            }
            "dorado" {
                scoop bucket add dorado https://github.com/chawyehsu/dorado
            }
            default {
                scoop bucket add $bucket
            }
        }
    }
}

# 安装并启用 aria2 加速
Write-Host "`n正在配置 aria2 加速..." -ForegroundColor Cyan

if (-not (Get-Command aria2c -ErrorAction SilentlyContinue)) {
    Write-Host "  正在安装 aria2..." -ForegroundColor Cyan
    scoop install aria2
}

# 启用 aria2
scoop config aria2-enabled true
scoop config aria2-retry-wait 4
scoop config aria2-split 16
scoop config aria2-max-connection-per-server 16
scoop config aria2-min-split-size 4M

# 安装常见工具
Write-Host "`n正在安装常见工具..." -ForegroundColor Cyan

$commonTools = @(
    @{ name = "7zip"; cmd = "7z" },
    @{ name = "unzip"; cmd = "unzip" },
    @{ name = "wget"; cmd = "wget" },
    @{ name = "curl"; cmd = "curl" },
    @{ name = "grep"; cmd = "grep" },
    @{ name = "sed"; cmd = "sed" },
    @{ name = "less"; cmd = "less" },
    @{ name = "touch"; cmd = "touch" }
)

foreach ($tool in $commonTools) {
    $toolName = $tool.name
    $toolCmd = $tool.cmd
    
    # 检查是否已安装 (通过 scoop list)
    $installed = scoop list | Where-Object { $_.Name -eq $toolName }
    
    if ($installed) {
        Write-Host "  $toolName 已安装，跳过" -ForegroundColor Gray
    } else {
        Write-Host "  正在安装 $toolName..." -ForegroundColor Cyan
        scoop install $toolName
    }
}

Write-Host "`nScoop 配置完成！" -ForegroundColor Green
Write-Host "已添加 bucket: $($buckets -join ', ')" -ForegroundColor Yellow
Write-Host "已启用 aria2 多线程下载加速" -ForegroundColor Yellow
Write-Host "已安装常见工具: $($commonTools.name -join ', ')" -ForegroundColor Yellow
