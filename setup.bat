@echo off
chcp 65001 >nul
echo ========================================
echo   LocationDetector Flutter 项目启动脚本
echo ========================================
echo.

REM 检查Flutter是否安装
where flutter >nul 2>nul
if %errorlevel% neq 0 (
    echo [错误] 未检测到Flutter，请先安装Flutter。
    echo 参考: INSTALL_FLUTTER.md
    pause
    exit /b 1
)

echo [1/5] 检查Flutter环境...
flutter --version
echo.

echo [2/5] 获取项目依赖...
flutter pub get
echo.

echo [3/5] 检查可用设备...
flutter devices
echo.

echo [4/5] 运行代码分析...
flutter analyze
echo.

echo ========================================
echo   环境准备完成！
echo ========================================
echo.
echo 接下来可以执行以下操作:
echo.
echo   1. 运行应用:        flutter run
echo   2. 构建APK:         flutter build apk
echo   3. 查看设备:        flutter devices
echo   4. 热重载开发:      flutter run (然后按 r)
echo   5. 清理缓存:        flutter clean
echo.
echo 请确保已启动Android模拟器或连接了真实设备。
echo.

pause
