# 安装基础软件 (gsudo, git, pwsh)

$installing = $false

# 检查并安装 gsudo
if (-not (Get-Command gsudo -ErrorAction SilentlyContinue)) {
    Write-Host "`n正在安装 gsudo..." -ForegroundColor Cyan
    winget install --id gerardog.gsudo --accept-source-agreements --accept-package-agreements
    $installing = $true
} else {
    Write-Host "`ngsudo 已安装，跳过" -ForegroundColor Gray
}

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


# 检查并安装 Git for Windows
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "`n正在安装 Git for Windows..." -ForegroundColor Cyan
    winget install --id Git.Git --accept-source-agreements --accept-package-agreements
    $installing = $true
    
    # 刷新环境变量
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
} else {
    Write-Host "`nGit 已安装，跳过" -ForegroundColor Gray
}

# 配置 Git 全局设置
if (Get-Command git -ErrorAction SilentlyContinue) {
    Write-Host "`n正在配置 Git 全局设置..." -ForegroundColor Cyan
    
    # 核心配置
    git config --global core.quotepath false          # 正确显示中文文件名
    git config --global core.autocrlf false           # 不自动转换换行符
    git config --global core.filemode false           # 忽略文件权限变化
    git config --global core.longpaths true           # 支持长路径
    git config --global core.safecrlf warn            # 换行符警告
    
    # 编码配置
    git config --global i18n.commitEncoding utf-8     # 提交信息编码
    git config --global i18n.logOutputEncoding utf-8  # 日志输出编码
    git config --global gui.encoding utf-8            # GUI 编码
    
    # 默认分支
    git config --global init.defaultBranch main
    
    # 拉取策略
    git config --global pull.rebase false             # 合并而非变基
    
    # VS Code 作为默认编辑器、diff 和 merge 工具
    git config --global core.editor "code --wait"
    git config --global diff.tool vscode
    git config --global difftool.vscode.cmd "code --wait --diff `$LOCAL `$REMOTE"
    git config --global difftool.prompt false         # 不提示确认
    git config --global merge.tool vscode
    git config --global mergetool.vscode.cmd "code --wait `$MERGED"
    git config --global mergetool.prompt false        # 不提示确认
    git config --global mergetool.keepBackup false
    
    # 创建全局 gitignore 文件
    $gitConfigDir = Join-Path $env:USERPROFILE ".config\git"
    if (-not (Test-Path $gitConfigDir)) {
        New-Item -ItemType Directory -Path $gitConfigDir -Force | Out-Null
    }
    
    # 全局 excludesfile (gitignore)
    $globalGitignore = Join-Path $gitConfigDir "ignore"
    $gitignoreContent = @"
# === OS generated files ===
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db
Desktop.ini

# === Editor/IDE ===
.idea/
.vscode/
*.swp
*.swo
*~
*.sublime-workspace
*.sublime-project

# === Logs and temp files ===
*.log
*.tmp
*.temp
*.bak
*.cache

# === Build outputs ===
node_modules/
dist/
build/
out/
target/
*.exe
*.dll
*.so
*.dylib

# === Package manager ===
npm-debug.log*
yarn-debug.log*
yarn-error.log*
pnpm-debug.log*

# === Environment files ===
.env
.env.local
.env.*.local
*.local

# === Python ===
__pycache__/
*.py[cod]
.Python
*.egg-info/
.eggs/
venv/
.venv/
"@
    Set-Content -Path $globalGitignore -Value $gitignoreContent -Encoding UTF8
    git config --global core.excludesfile $globalGitignore
    
    # 全局 attributesfile
    $globalGitattributes = Join-Path $gitConfigDir "attributes"
    $gitattributesContent = @"
# === Auto detect text files and perform LF normalization ===
* text=auto

# === Documents ===
*.md text diff=markdown
*.txt text
*.csv text
*.json text
*.xml text
*.yaml text
*.yml text
*.toml text

# === Scripts ===
*.sh text eol=lf
*.bash text eol=lf
*.zsh text eol=lf
*.ps1 text eol=crlf
*.cmd text eol=crlf
*.bat text eol=crlf

# === Source code ===
*.js text
*.ts text
*.jsx text
*.tsx text
*.vue text
*.css text
*.scss text
*.less text
*.html text
*.htm text
*.py text
*.rb text
*.go text
*.rs text
*.java text
*.c text
*.cpp text
*.h text
*.hpp text
*.cs text

# === Config files ===
*.ini text
*.conf text
*.config text
.gitignore text
.gitattributes text
.editorconfig text
Dockerfile text
Makefile text

# === Binary files ===
*.png binary
*.jpg binary
*.jpeg binary
*.gif binary
*.ico binary
*.webp binary
*.svg text
*.pdf binary
*.zip binary
*.tar binary
*.gz binary
*.7z binary
*.rar binary
*.exe binary
*.dll binary
*.so binary
*.dylib binary
*.ttf binary
*.otf binary
*.woff binary
*.woff2 binary
*.eot binary

# === Diff settings ===
*.md diff=markdown
*.png diff=exif
*.jpg diff=exif
*.jpeg diff=exif

# === Git LFS ===
# Large binary files - tracked by LFS
*.psd filter=lfs diff=lfs merge=lfs -text
*.ai filter=lfs diff=lfs merge=lfs -text
*.sketch filter=lfs diff=lfs merge=lfs -text
*.fig filter=lfs diff=lfs merge=lfs -text
*.xd filter=lfs diff=lfs merge=lfs -text
*.mp4 filter=lfs diff=lfs merge=lfs -text
*.mov filter=lfs diff=lfs merge=lfs -text
*.avi filter=lfs diff=lfs merge=lfs -text
*.mkv filter=lfs diff=lfs merge=lfs -text
*.webm filter=lfs diff=lfs merge=lfs -text
*.mp3 filter=lfs diff=lfs merge=lfs -text
*.wav filter=lfs diff=lfs merge=lfs -text
*.flac filter=lfs diff=lfs merge=lfs -text
*.ogg filter=lfs diff=lfs merge=lfs -text
*.iso filter=lfs diff=lfs merge=lfs -text
*.dmg filter=lfs diff=lfs merge=lfs -text
*.msi filter=lfs diff=lfs merge=lfs -text
*.deb filter=lfs diff=lfs merge=lfs -text
*.rpm filter=lfs diff=lfs merge=lfs -text
*.apk filter=lfs diff=lfs merge=lfs -text
*.ipa filter=lfs diff=lfs merge=lfs -text
*.unitypackage filter=lfs diff=lfs merge=lfs -text
*.fbx filter=lfs diff=lfs merge=lfs -text
*.obj filter=lfs diff=lfs merge=lfs -text
*.blend filter=lfs diff=lfs merge=lfs -text
*.3ds filter=lfs diff=lfs merge=lfs -text
*.max filter=lfs diff=lfs merge=lfs -text
"@
    Set-Content -Path $globalGitattributes -Value $gitattributesContent -Encoding UTF8
    git config --global core.attributesfile $globalGitattributes
    
    # 配置 Git LFS
    Write-Host "正在配置 Git LFS..." -ForegroundColor Cyan
    git lfs install
    
    # LFS 配置
    git config --global lfs.concurrenttransfers 8     # 并发传输数
    git config --global lfs.batch true                # 批量传输
    
    Write-Host "Git 全局配置完成！" -ForegroundColor Green
    Write-Host "  - 已配置中文支持和 UTF-8 编码" -ForegroundColor Gray
    Write-Host "  - 已配置 VS Code 作为默认编辑器/diff/merge 工具" -ForegroundColor Gray
    Write-Host "  - 已配置默认分支为 main" -ForegroundColor Gray
    Write-Host "  - 已创建全局 gitignore: $globalGitignore" -ForegroundColor Gray
    Write-Host "  - 已创建全局 gitattributes: $globalGitattributes" -ForegroundColor Gray
    Write-Host "  - 已配置 Git LFS 大文件支持" -ForegroundColor Gray
}

# 检查并安装 PowerShell (PowerShell 7+)
if (-not (Get-Command pwsh -ErrorAction SilentlyContinue)) {
    Write-Host "`n正在安装 PowerShell..." -ForegroundColor Cyan
    winget install --id Microsoft.PowerShell --accept-source-agreements --accept-package-agreements
    $installing = $true
} else {
    Write-Host "`nPowerShell 已安装，跳过" -ForegroundColor Gray
}

if ($installing) {
    Write-Host "`n基础工具安装完成。" -ForegroundColor Green
    Write-Host "请重新打开终端以使环境变量生效。" -ForegroundColor Yellow
}
