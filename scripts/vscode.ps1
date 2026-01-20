# 安装 Visual Studio Code 及常用插件

Write-Host "安装 Visual Studio Code..." -ForegroundColor Green

# 检查并安装 VS Code
if (-not (Get-Command code -ErrorAction SilentlyContinue)) {
    Write-Host "`n正在安装 VS Code..." -ForegroundColor Cyan
    # 使用 winget 安装，包含右键菜单选项
    winget install --id Microsoft.VisualStudioCode --accept-source-agreements --accept-package-agreements --override '/SILENT /mergetasks="!runcode,addcontextmenufiles,addcontextmenufolders,associatewithfiles,addtopath"'

    # 刷新环境变量
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
} else {
    Write-Host "`nVS Code 已安装，跳过" -ForegroundColor Gray
}

# 再次检查 code 命令是否可用
if (-not (Get-Command code -ErrorAction SilentlyContinue)) {
    Write-Host "VS Code 安装完成，请重新打开终端后再运行此脚本安装插件" -ForegroundColor Yellow
    exit 0
}

Write-Host "`n正在安装常用插件..." -ForegroundColor Cyan

# 常用插件列表
$extensions = @(
    # 中文语言包
    "MS-CEINTL.vscode-language-pack-zh-hans"

    # Git 相关
    "eamodio.gitlens"
    "mhutchie.git-graph"

    # 代码格式化
    "esbenp.prettier-vscode"
    "EditorConfig.EditorConfig"

    # 开发工具
    "formulahendry.code-runner"
    "usernamehw.errorlens"
    "streetsidesoftware.code-spell-checker"

    # 主题和图标
    "PKief.material-icon-theme"

    # AI 辅助
    "anthropic.claude-code"

    # Web 开发
    "dbaeumer.vscode-eslint"
    "bradlc.vscode-tailwindcss"

    # Markdown
    "yzhang.markdown-all-in-one"

    # 远程开发
    "ms-vscode-remote.remote-ssh"
    "ms-vscode-remote.remote-wsl"

    # Docker
    "ms-azuretools.vscode-docker"

    # YAML/JSON
    "redhat.vscode-yaml"
)

foreach ($ext in $extensions) {
    Write-Host "  安装 $ext..." -ForegroundColor Gray
    code --install-extension $ext --force 2>$null
}

Write-Host "`nVS Code 及插件安装完成！" -ForegroundColor Green
Write-Host "已安装 $($extensions.Count) 个插件" -ForegroundColor Yellow

Write-Host "`n已启用的功能:" -ForegroundColor Cyan
Write-Host "  - 添加到文件右键菜单 (Open with Code)" -ForegroundColor Gray
Write-Host "  - 添加到文件夹右键菜单 (Open with Code)" -ForegroundColor Gray
Write-Host "  - 添加到 PATH 环境变量" -ForegroundColor Gray
