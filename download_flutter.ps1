# Flutter自动下载安装脚本
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "   自动下载并安装Flutter SDK" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# 设置路径
$installDir = "C:\src"
$flutterZip = "$installDir\flutter_windows_stable.zip"
$flutterDir = "$installDir\flutter"
$flutterBin = "$flutterDir\bin"

# 创建目录
Write-Host "[1/5] 创建安装目录..." -ForegroundColor Green
if (-not (Test-Path $installDir)) {
    New-Item -ItemType Directory -Path $installDir -Force | Out-Null
}
Write-Host "✓ 目录: $installDir" -ForegroundColor Green
Write-Host ""

# 检查是否已安装
if (Test-Path "$flutterBin\flutter.bat") {
    Write-Host "Flutter已经安装！" -ForegroundColor Yellow
    & "$flutterBin\flutter.bat" --version
    Write-Host ""
    Write-Host "跳过下载，直接配置环境变量..." -ForegroundColor Yellow
    goto ConfigureEnv
}

# 下载Flutter
Write-Host "[2/5] 下载Flutter SDK..." -ForegroundColor Green
Write-Host "URL: https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.16.9-stable.zip" -ForegroundColor Cyan
Write-Host "大小: 约800MB" -ForegroundColor Yellow
Write-Host "保存到: $flutterZip" -ForegroundColor Cyan
Write-Host ""
Write-Host "开始下载，请稍候..." -ForegroundColor Yellow

$url = "https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.16.9-stable.zip"

try {
    # 创建WebClient
    $webClient = New-Object System.Net.WebClient

    # 下载文件
    $webClient.DownloadFile($url, $flutterZip)

    Write-Host ""
    Write-Host "✓ 下载完成！" -ForegroundColor Green

    # 显示文件大小
    $fileSize = (Get-Item $flutterZip).Length / 1MB
    Write-Host "文件大小: $([math]::Round($fileSize, 2)) MB" -ForegroundColor Cyan
} catch {
    Write-Host ""
    Write-Host "✗ 下载失败: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    Write-Host "请尝试以下方法之一:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "方法1: 使用国内镜像" -ForegroundColor Cyan
    Write-Host "  https://storage.flutter-io.cn/flutter_infra_release/releases/stable/windows/flutter_windows_3.16.9-stable.zip" -ForegroundColor White
    Write-Host ""
    Write-Host "方法2: 手动下载" -ForegroundColor Cyan
    Write-Host "  1. 访问: https://docs.flutter.dev/get-started/install/windows" -ForegroundColor White
    Write-Host "  2. 下载zip文件" -ForegroundColor White
    Write-Host "  3. 保存到: $flutterZip" -ForegroundColor White
    Write-Host "  4. 再次运行此脚本" -ForegroundColor White
    Write-Host ""

    Read-Host "按回车键退出"
    exit 1
}

Write-Host ""

# 解压
Write-Host "[3/5] 解压Flutter SDK..." -ForegroundColor Green
Write-Host "解压到: $installDir" -ForegroundColor Cyan

try {
    Expand-Archive -Path $flutterZip -DestinationPath $installDir -Force
    Write-Host "✓ 解压完成！" -ForegroundColor Green

    # 删除zip文件
    Remove-Item $flutterZip -Force
    Write-Host "✓ 已清理临时文件" -ForegroundColor Green
} catch {
    Write-Host "✗ 解压失败: $($_.Exception.Message)" -ForegroundColor Red
    Read-Host "按回车键退出"
    exit 1
}

Write-Host ""

:ConfigureEnv
# 配置环境变量
Write-Host "[4/5] 配置环境变量..." -ForegroundColor Green

$userPath = [Environment]::GetEnvironmentVariable("Path", "User")

if ($userPath -like "*$flutterBin*") {
    Write-Host "✓ Flutter已在环境变量中" -ForegroundColor Green
} else {
    $newPath = $userPath + ";$flutterBin"
    [Environment]::SetEnvironmentVariable("Path", $newPath, "User")

    # 同时更新当前会话
    $env:Path = $env:Path + ";$flutterBin"

    Write-Host "✓ 已添加到环境变量Path" -ForegroundColor Green
}

Write-Host ""

# 验证安装
Write-Host "[5/5] 验证Flutter安装..." -ForegroundColor Green

# 刷新环境变量
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

try {
    Write-Host ""
    & "$flutterBin\flutter.bat" --version
    Write-Host ""
    Write-Host "✓ Flutter安装成功！" -ForegroundColor Green
} catch {
    Write-Host "验证失败，请手动运行: flutter --version" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "   ✓ 安装完成！" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "下一步操作:" -ForegroundColor Yellow
Write-Host "1. 关闭当前终端，打开新的终端（刷新环境变量）" -ForegroundColor White
Write-Host "2. 运行: cd E:\IOSDATA\LocationDetectorFlutter" -ForegroundColor White
Write-Host "3. 运行: flutter pub get" -ForegroundColor White
Write-Host "4. 运行: flutter run -d windows" -ForegroundColor White
Write-Host ""
Write-Host "或直接运行启动脚本:" -ForegroundColor Yellow
Write-Host "  E:\IOSDATA\LocationDetectorFlutter\START.bat" -ForegroundColor White
Write-Host ""

Read-Host "按回车键退出"
