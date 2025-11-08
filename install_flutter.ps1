# Flutter自动安装脚本（Windows）
# 需要以管理员身份运行PowerShell

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "   Flutter SDK 自动安装脚本" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# 检查是否以管理员身份运行
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "警告: 建议以管理员身份运行此脚本以配置环境变量" -ForegroundColor Yellow
    Write-Host "请右键点击PowerShell，选择'以管理员身份运行'" -ForegroundColor Yellow
    Write-Host ""
    $continue = Read-Host "是否继续？(y/n)"
    if ($continue -ne 'y') {
        exit
    }
}

# 设置安装目录
$FLUTTER_DIR = "C:\src\flutter"
$FLUTTER_BIN = "$FLUTTER_DIR\bin"

Write-Host "[1/6] 检查安装目录..." -ForegroundColor Green

# 检查是否已安装
if (Test-Path $FLUTTER_BIN) {
    Write-Host "Flutter已安装在: $FLUTTER_DIR" -ForegroundColor Yellow
    $reinstall = Read-Host "是否重新安装？(y/n)"
    if ($reinstall -ne 'y') {
        Write-Host "跳过安装，直接配置环境变量..." -ForegroundColor Yellow
        goto ConfigureEnv
    } else {
        Write-Host "删除旧版本..." -ForegroundColor Yellow
        Remove-Item -Path $FLUTTER_DIR -Recurse -Force -ErrorAction SilentlyContinue
    }
}

# 创建目录
Write-Host "创建安装目录: $FLUTTER_DIR" -ForegroundColor Cyan
New-Item -ItemType Directory -Path "C:\src" -Force | Out-Null

Write-Host ""
Write-Host "[2/6] 下载Flutter SDK..." -ForegroundColor Green
Write-Host "这可能需要5-10分钟，请耐心等待..." -ForegroundColor Yellow
Write-Host ""

# 下载Flutter SDK
$FLUTTER_ZIP = "C:\src\flutter_windows_stable.zip"
$FLUTTER_URL = "https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.16.9-stable.zip"

try {
    # 使用Start-BitsTransfer下载（支持断点续传）
    Write-Host "开始下载: $FLUTTER_URL" -ForegroundColor Cyan
    Import-Module BitsTransfer
    Start-BitsTransfer -Source $FLUTTER_URL -Destination $FLUTTER_ZIP -Description "下载Flutter SDK" -DisplayName "Flutter SDK"

    Write-Host "✓ 下载完成！" -ForegroundColor Green
} catch {
    Write-Host "使用BitsTransfer下载失败，尝试使用WebClient..." -ForegroundColor Yellow

    $webClient = New-Object System.Net.WebClient
    $webClient.DownloadFile($FLUTTER_URL, $FLUTTER_ZIP)

    if (Test-Path $FLUTTER_ZIP) {
        Write-Host "✓ 下载完成！" -ForegroundColor Green
    } else {
        Write-Host "✗ 下载失败" -ForegroundColor Red
        Write-Host ""
        Write-Host "请手动下载Flutter SDK:" -ForegroundColor Yellow
        Write-Host "1. 访问: https://docs.flutter.dev/get-started/install/windows"
        Write-Host "2. 下载最新stable版本"
        Write-Host "3. 解压到: C:\src\flutter"
        Write-Host "4. 然后运行此脚本跳过下载步骤"
        exit 1
    }
}

Write-Host ""
Write-Host "[3/6] 解压Flutter SDK..." -ForegroundColor Green
Write-Host "解压到: C:\src\" -ForegroundColor Cyan

try {
    # 使用Expand-Archive解压
    Expand-Archive -Path $FLUTTER_ZIP -DestinationPath "C:\src" -Force
    Write-Host "✓ 解压完成！" -ForegroundColor Green
} catch {
    Write-Host "✗ 解压失败: $_" -ForegroundColor Red
    exit 1
}

# 删除下载的zip文件
Remove-Item -Path $FLUTTER_ZIP -Force -ErrorAction SilentlyContinue

:ConfigureEnv
Write-Host ""
Write-Host "[4/6] 配置环境变量..." -ForegroundColor Green

# 获取当前用户的Path
$userPath = [Environment]::GetEnvironmentVariable("Path", "User")

# 检查是否已添加
if ($userPath -like "*$FLUTTER_BIN*") {
    Write-Host "Flutter已在环境变量Path中" -ForegroundColor Yellow
} else {
    Write-Host "添加Flutter到环境变量Path..." -ForegroundColor Cyan

    # 添加到Path
    $newPath = $userPath + ";$FLUTTER_BIN"
    [Environment]::SetEnvironmentVariable("Path", $newPath, "User")

    # 同时更新当前会话
    $env:Path = $env:Path + ";$FLUTTER_BIN"

    Write-Host "✓ 环境变量已配置！" -ForegroundColor Green
}

Write-Host ""
Write-Host "[5/6] 验证Flutter安装..." -ForegroundColor Green

# 刷新环境变量
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

# 运行flutter --version
try {
    $flutterVersion = & "$FLUTTER_BIN\flutter.bat" --version 2>&1
    Write-Host $flutterVersion -ForegroundColor Cyan
    Write-Host ""
    Write-Host "✓ Flutter安装成功！" -ForegroundColor Green
} catch {
    Write-Host "✗ 验证失败: $_" -ForegroundColor Red
    Write-Host "请手动运行: flutter --version" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "[6/6] 运行Flutter Doctor..." -ForegroundColor Green
Write-Host "检查开发环境..." -ForegroundColor Cyan
Write-Host ""

try {
    & "$FLUTTER_BIN\flutter.bat" doctor
} catch {
    Write-Host "Flutter doctor运行失败" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "   ✓ Flutter安装完成！" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "下一步：" -ForegroundColor Yellow
Write-Host "1. 关闭并重新打开终端（刷新环境变量）" -ForegroundColor White
Write-Host "2. 运行: cd E:\IOSDATA\LocationDetectorFlutter" -ForegroundColor White
Write-Host "3. 运行: flutter pub get" -ForegroundColor White
Write-Host "4. 运行: flutter run" -ForegroundColor White
Write-Host ""
Write-Host "或者直接运行自动化脚本:" -ForegroundColor Yellow
Write-Host "   .\START.bat" -ForegroundColor White
Write-Host ""

Write-Host "按任意键退出..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
