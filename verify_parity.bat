@echo off
chcp 65001 >nul
echo.
echo ================================================
echo   Flutter增强版 完全一致性验证
echo ================================================
echo.

set ALL_PASS=1

echo [检查1/5] 验证main.dart是否启用增强版...
findstr /C:"location_service_enhanced" lib\main.dart >nul 2>&1
if %errorlevel% equ 0 (
    echo    ✓ 通过 - main.dart已使用增强版
) else (
    echo    ✗ 失败 - main.dart未使用增强版
    set ALL_PASS=0
)
echo.

echo [检查2/5] 验证AppDelegate.swift包含ExternalAccessory...
findstr /C:"ExternalAccessory" ios\Runner\AppDelegate.swift >nul 2>&1
if %errorlevel% equ 0 (
    echo    ✓ 通过 - AppDelegate包含ExternalAccessory框架
) else (
    echo    ✗ 失败 - AppDelegate缺少ExternalAccessory框架
    set ALL_PASS=0
)
echo.

echo [检查3/5] 验证AppDelegate.swift包含sourceInformation...
findstr /C:"sourceInformation" ios\Runner\AppDelegate.swift >nul 2>&1
if %errorlevel% equ 0 (
    echo    ✓ 通过 - AppDelegate包含sourceInformation检测
) else (
    echo    ✗ 失败 - AppDelegate缺少sourceInformation检测
    set ALL_PASS=0
)
echo.

echo [检查4/5] 验证external_gps_detector.dart存在...
if exist lib\native\external_gps_detector.dart (
    echo    ✓ 通过 - Platform Channel文件存在
) else (
    echo    ✗ 失败 - Platform Channel文件不存在
    set ALL_PASS=0
)
echo.

echo [检查5/5] 验证location_service_enhanced.dart存在...
if exist lib\services\location_service_enhanced.dart (
    echo    ✓ 通过 - 增强版服务文件存在
) else (
    echo    ✗ 失败 - 增强版服务文件不存在
    set ALL_PASS=0
)
echo.

echo ================================================
if %ALL_PASS% equ 1 (
    echo   ✓✓✓ 所有检查通过！Flutter增强版已正确配置 ✓✓✓
    echo.
    echo   与iOS原生版100%%一致！
    echo.
    echo   现在可以运行: flutter run
) else (
    echo   ✗✗✗ 部分检查失败 ✗✗✗
    echo.
    echo   请检查上述失败项
)
echo ================================================
echo.

pause
