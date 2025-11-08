Write-Host "================================================" -ForegroundColor Cyan
Write-Host "   Flutter SDK 下载器" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

$url = "https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.16.9-stable.zip"
$output = "C:\src\flutter_windows_stable.zip"

if (!(Test-Path "C:\src")) {
    New-Item -ItemType Directory -Path "C:\src" -Force | Out-Null
}

if (Test-Path "C:\src\flutter\bin\flutter.bat") {
    Write-Host "Flutter已安装！" -ForegroundColor Green
    & "C:\src\flutter\bin\flutter.bat" --version
    exit 0
}

Write-Host "下载 Flutter SDK..." -ForegroundColor Yellow
Write-Host "URL: $url" -ForegroundColor Cyan
Write-Host "大小: 约800MB，请耐心等待..." -ForegroundColor Yellow
Write-Host ""

try {
    Invoke-WebRequest -Uri $url -OutFile $output -UseBasicParsing
    Write-Host ""
    Write-Host "下载完成！" -ForegroundColor Green

    Write-Host "正在解压..." -ForegroundColor Yellow
    Expand-Archive -Path $output -DestinationPath "C:\src" -Force
    Write-Host "解压完成！" -ForegroundColor Green

    Remove-Item $output -Force
    Write-Host "安装完成！" -ForegroundColor Green

} catch {
    Write-Host "下载失败: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
