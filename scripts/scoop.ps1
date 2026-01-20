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
    Write-Host "`n是否需要配置代理?" -ForegroundColor Cyan
    Write-Host "  1) 是" -ForegroundColor Gray
    Write-Host "  2) 否 (跳过)" -ForegroundColor Gray
    $proxyChoice = Read-Host "请输入序号 (1-2)"

    if ($proxyChoice -eq "1") {
        Write-Host "`n请输入代理地址 (格式: http://127.0.0.1:7890 或 [username:password@]host:port):" -ForegroundColor Cyan
        $proxyUrl = Read-Host "代理地址"

        if (-not [string]::IsNullOrWhiteSpace($proxyUrl)) {
            Write-Host "正在配置代理..." -ForegroundColor Cyan
            scoop config proxy $proxyUrl
            Write-Host "代理配置完成！" -ForegroundColor Green
        } else {
            Write-Host "未输入代理地址，跳过配置" -ForegroundColor Yellow
        }
    } else {
        Write-Host "跳过代理配置" -ForegroundColor Yellow
    }
} else {
    Write-Host "Scoop 已安装，跳过安装步骤" -ForegroundColor Gray

    # 检查是否需要配置或修改代理
    Write-Host "`n是否需要配置或修改代理?" -ForegroundColor Cyan
    Write-Host "  1) 是" -ForegroundColor Gray
    Write-Host "  2) 否 (跳过)" -ForegroundColor Gray
    $proxyChoice = Read-Host "请输入序号 (1-2)"

    if ($proxyChoice -eq "1") {
        Write-Host "`n请输入代理地址 (格式: http://127.0.0.1:7890 或 [username:password@]host:port):" -ForegroundColor Cyan
        Write-Host "留空则删除现有代理配置" -ForegroundColor Gray
        $proxyUrl = Read-Host "代理地址"

        if (-not [string]::IsNullOrWhiteSpace($proxyUrl)) {
            Write-Host "正在配置代理..." -ForegroundColor Cyan
            scoop config proxy $proxyUrl
            Write-Host "代理配置完成！" -ForegroundColor Green
        } else {
            Write-Host "正在删除代理配置..." -ForegroundColor Cyan
            scoop config rm proxy
            Write-Host "代理配置已删除" -ForegroundColor Green
        }
    } else {
        Write-Host "跳过代理配置" -ForegroundColor Yellow
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

Write-Host "`nScoop 配置完成！" -ForegroundColor Green
Write-Host "已添加 bucket: $($buckets -join ', ')" -ForegroundColor Yellow
Write-Host "已启用 aria2 多线程下载加速" -ForegroundColor Yellow
