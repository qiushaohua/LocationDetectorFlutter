@echo off
chcp 65001 >nul
echo.
echo ================================================
echo   LocationDetector Flutter版 - 快速运行指南
echo ================================================
echo.

REM 检查Flutter是否安装
where flutter >nul 2>nul
if %errorlevel% neq 0 (
    echo ❌ Flutter未安装
    echo.
    echo 请按照以下步骤安装Flutter：
    echo.
    echo 【方法1：自动安装（推荐）】
    echo 1. 访问: https://docs.flutter.dev/get-started/install/windows
    echo 2. 点击下载Flutter SDK
    echo 3. 解压到 C:\src\flutter
    echo 4. 添加到环境变量Path: C:\src\flutter\bin
    echo 5. 重启终端，再运行此脚本
    echo.
    echo 【方法2：使用Git克隆】
    echo    git clone https://github.com/flutter/flutter.git -b stable C:\src\flutter
    echo    然后添加C:\src\flutter\bin到环境变量Path
    echo.
    echo 详细安装指南请查看: INSTALL_FLUTTER.md
    echo.
    pause
    exit /b 1
)

echo ✓ Flutter已安装
flutter --version
echo.

echo ================================================
echo   正在准备运行项目...
echo ================================================
echo.

echo [1/4] 获取项目依赖...
flutter pub get
if %errorlevel% neq 0 (
    echo ❌ 获取依赖失败
    pause
    exit /b 1
)
echo.

echo [2/4] 检查可用设备...
flutter devices
echo.

echo [3/4] 检查设备连接状态...
for /f "tokens=*" %%i in ('flutter devices ^| find /c "No devices"') do set NO_DEVICES=%%i

if %NO_DEVICES% gtr 0 (
    echo.
    echo ❌ 未检测到可用设备
    echo.
    echo 请选择以下方式之一：
    echo.
    echo 【选项1：启动Android模拟器】
    echo 1. 打开Android Studio
    echo 2. Tools ^> Device Manager
    echo 3. 点击模拟器的播放按钮
    echo 4. 等待模拟器启动完成
    echo 5. 再运行此脚本
    echo.
    echo 【选项2：连接真实Android设备】
    echo 1. 手机开启开发者选项和USB调试
    echo 2. 用USB连接手机到电脑
    echo 3. 手机上点击"允许USB调试"
    echo 4. 再运行此脚本
    echo.
    echo 【选项3：使用Windows桌面模式（仅测试UI）】
    echo    flutter run -d windows
    echo    注意：GPS功能需要真实移动设备测试
    echo.
    pause
    exit /b 1
)

echo.
echo ================================================
echo   [4/4] 启动应用...
echo ================================================
echo.
echo 首次编译需要5-10分钟，请耐心等待...
echo 编译完成后可使用热重载（按r键）快速刷新
echo.
echo 提示：
echo   - 按 r = 热重载
echo   - 按 R = 热重启
echo   - 按 q = 退出
echo   - 按 h = 帮助
echo.

flutter run

pause
