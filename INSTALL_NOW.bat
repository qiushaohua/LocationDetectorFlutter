@echo off
chcp 65001 >nul
echo.
echo ================================================
echo    Flutter自动安装器
echo ================================================
echo.
echo 此脚本将自动下载并安装Flutter SDK
echo.
echo 安装位置: C:\src\flutter
echo 预计时间: 5-10分钟
echo.
echo 按任意键开始安装...
pause >nul

echo.
echo 正在以管理员权限启动PowerShell...
echo 如果出现UAC提示，请点击"是"
echo.

PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& {Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File ""%~dp0install_flutter.ps1""' -Verb RunAs}"

echo.
echo 安装脚本已在新窗口中启动
echo 请在PowerShell窗口中查看安装进度
echo.
pause
