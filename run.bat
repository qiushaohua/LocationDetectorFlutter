@echo off
chcp 65001 >nul
echo ========================================
echo   启动 LocationDetector 应用
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

echo 正在检查可用设备...
flutter devices
echo.

echo ========================================
echo 提示:
echo   - 确保已启动Android模拟器或连接设备
echo   - 首次运行需要较长时间编译
echo   - 编译完成后可以使用热重载 (按 r)
echo ========================================
echo.

echo 开始运行应用...
flutter run

pause
