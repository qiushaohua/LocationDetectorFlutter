@echo off
chcp 65001 >nul
cls
echo ================================================
echo    Flutter SDK 自动下载安装器
echo ================================================
echo.
echo 正在准备下载Flutter SDK...
echo 文件大小: 约800MB
echo 预计时间: 5-10分钟
echo.
echo 按任意键开始下载...
pause >nul

echo.
echo 正在下载Flutter SDK...
echo 这可能需要几分钟，请保持网络连接...
echo.

REM 使用PowerShell下载
powershell -Command ^
"$ProgressPreference = 'SilentlyContinue'; ^
$url = 'https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.16.9-stable.zip'; ^
$output = 'C:\src\flutter_windows_stable.zip'; ^
if (!(Test-Path 'C:\src')) { New-Item -ItemType Directory -Path 'C:\src' | Out-Null }; ^
Write-Host 'Downloading Flutter SDK...'; ^
Invoke-WebRequest -Uri $url -OutFile $output -UseBasicParsing; ^
Write-Host 'Download complete!'; ^
Write-Host 'Extracting...'; ^
Expand-Archive -Path $output -DestinationPath 'C:\src' -Force; ^
Remove-Item $output; ^
Write-Host 'Installation complete!'"

if %errorlevel% equ 0 (
    echo.
    echo ✓ 下载和解压完成！
    echo.
    echo 正在配置环境变量...

    REM 添加到环境变量
    powershell -Command "[Environment]::SetEnvironmentVariable('Path', $env:Path + ';C:\src\flutter\bin', 'User')"

    echo ✓ 环境变量已配置
    echo.
    echo ================================================
    echo    ✓ Flutter安装完成！
    echo ================================================
    echo.
    echo 下一步:
    echo 1. 关闭此窗口
    echo 2. 打开新的CMD或PowerShell
    echo 3. 运行: flutter --version
    echo 4. 运行: cd E:\IOSDATA\LocationDetectorFlutter
    echo 5. 运行: flutter pub get
    echo 6. 运行: flutter run -d windows
    echo.
) else (
    echo.
    echo ✗ 下载失败
    echo.
    echo 请尝试手动下载:
    echo 访问: https://docs.flutter.dev/get-started/install/windows
    echo 下载zip文件并解压到: C:\src\flutter
    echo.
)

pause
