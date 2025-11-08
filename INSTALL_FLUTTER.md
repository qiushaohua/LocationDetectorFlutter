# Windows上安装Flutter完整指南

本指南帮助你在Windows电脑上从零开始安装Flutter开发环境。

---

## 系统要求

- **操作系统**: Windows 10 或更高版本（64位）
- **磁盘空间**: 至少 5GB 空闲空间
- **内存**: 建议 8GB RAM 或更多
- **工具**: Git for Windows

---

## 第一步：安装Git

Flutter需要Git来管理依赖。

1. 下载Git: https://git-scm.com/download/win
2. 运行安装程序，使用默认选项
3. 验证安装:
   ```powershell
   git --version
   ```

---

## 第二步：下载并安装Flutter SDK

### 方法A：直接下载（推荐新手）

1. **下载Flutter SDK**
   - 访问: https://docs.flutter.dev/get-started/install/windows
   - 下载最新稳定版ZIP文件（约800MB）
   - 例如: `flutter_windows_3.16.0-stable.zip`

2. **解压Flutter**
   - 解压到 `C:\src\flutter` （推荐）
   - ⚠️ **不要**解压到需要管理员权限的目录（如 `C:\Program Files`）

3. **配置环境变量**

   **方法1：使用图形界面**
   - 右键点击"此电脑" > 属性
   - 点击"高级系统设置"
   - 点击"环境变量"
   - 在"用户变量"下找到"Path"，点击"编辑"
   - 点击"新建"，添加: `C:\src\flutter\bin`
   - 点击"确定"保存

   **方法2：使用PowerShell**（以管理员身份运行）
   ```powershell
   [Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\src\flutter\bin", "User")
   ```

4. **验证安装**
   - 打开**新的** PowerShell 或 CMD 窗口
   - 运行:
     ```powershell
     flutter --version
     flutter doctor
     ```

### 方法B：使用Git克隆（推荐开发者）

```powershell
# 创建目录
mkdir C:\src
cd C:\src

# 克隆Flutter仓库
git clone https://github.com/flutter/flutter.git -b stable

# 添加到环境变量（见上面"方法1"或"方法2"）
```

---

## 第三步：运行 `flutter doctor`

`flutter doctor` 会检查你的环境，显示缺失的依赖。

```powershell
flutter doctor
```

**输出示例**:
```
Doctor summary (to see all details, run flutter doctor -v):
[✓] Flutter (Channel stable, 3.16.0, on Microsoft Windows)
[✗] Android toolchain - develop for Android devices
    ✗ Android SDK not found.
[✗] Chrome - develop for the web (Cannot find Chrome executable)
[✗] Visual Studio - develop Windows apps
[✗] Android Studio (not installed)
[✗] VS Code (version 1.85)
[!] Connected device
    ! No devices available
```

不用担心！接下来我们会逐个解决这些问题。

---

## 第四步：安装Android Studio（必需，用于Android开发）

### 为什么需要Android Studio？
- 提供Android SDK
- 提供Android模拟器
- 提供开发工具

### 安装步骤

1. **下载Android Studio**
   - 访问: https://developer.android.com/studio
   - 下载最新版本（约1GB）

2. **安装Android Studio**
   - 运行安装程序
   - 选择"Standard"标准安装
   - 等待下载Android SDK组件（约2-3GB）

3. **配置Android SDK**
   - 打开Android Studio
   - 点击 "More Actions" > "SDK Manager"
   - 确保安装了:
     - ✅ Android SDK Platform (最新版本)
     - ✅ Android SDK Command-line Tools
     - ✅ Android SDK Build-Tools
     - ✅ Android Emulator

4. **接受Android许可**
   ```powershell
   flutter doctor --android-licenses
   ```
   一路输入 `y` 接受所有许可。

5. **创建Android虚拟设备（模拟器）**
   - 打开Android Studio
   - 点击 "More Actions" > "Virtual Device Manager"
   - 点击 "Create Device"
   - 选择 "Pixel 5" 或其他设备
   - 选择系统镜像（推荐最新版本，如 "Tiramisu" API 33）
   - 下载系统镜像（约1GB）
   - 完成创建

---

## 第五步：安装VS Code（推荐，轻量级编辑器）

### 安装VS Code

1. **下载VS Code**
   - 访问: https://code.visualstudio.com/
   - 下载Windows版本

2. **安装Flutter插件**
   - 打开VS Code
   - 按 `Ctrl+Shift+X` 打开扩展市场
   - 搜索 "Flutter"
   - 安装 "Flutter" 插件（会自动安装Dart插件）

3. **验证配置**
   - 按 `Ctrl+Shift+P` 打开命令面板
   - 输入 "Flutter: Run Flutter Doctor"
   - 查看结果

---

## 第六步：最终验证

再次运行 `flutter doctor`:

```powershell
flutter doctor
```

**期望的结果**:
```
Doctor summary (to see all details, run flutter doctor -v):
[✓] Flutter (Channel stable, 3.16.0, on Microsoft Windows)
[✓] Android toolchain - develop for Android devices (Android SDK version 34.0.0)
[✓] Chrome - develop for the web
[✓] Visual Studio - develop Windows apps
[✓] Android Studio (version 2023.1)
[✓] VS Code (version 1.85)
[✓] Connected device (1 available)
[✓] Network resources
```

所有项目显示 `✓` 就表示环境配置完成！

---

## 常见问题解决

### ❌ Android SDK not found

**解决方法**:
```powershell
flutter config --android-sdk "C:\Users\你的用户名\AppData\Local\Android\Sdk"
```

### ❌ cmdline-tools component is missing

**解决方法**:
1. 打开Android Studio
2. Tools > SDK Manager
3. SDK Tools 标签页
4. 勾选 "Android SDK Command-line Tools"
5. 点击 Apply

### ❌ Unable to find git in your PATH

**解决方法**:
1. 安装Git: https://git-scm.com/download/win
2. 重启终端

### ❌ Android licenses not accepted

**解决方法**:
```powershell
flutter doctor --android-licenses
# 一路输入 y
```

---

## 下一步

环境安装完成后，你可以:

1. **运行示例项目**
   ```powershell
   cd E:\IOSDATA\LocationDetectorFlutter
   flutter pub get
   flutter run
   ```

2. **启动模拟器**
   ```powershell
   flutter emulators
   flutter emulators --launch <emulator_name>
   ```

3. **查看可用设备**
   ```powershell
   flutter devices
   ```

---

## 更新Flutter

定期更新Flutter以获得最新功能和修复:

```powershell
flutter upgrade
```

---

## 卸载Flutter（如需要）

1. 删除Flutter目录: `C:\src\flutter`
2. 从环境变量Path中移除Flutter路径
3. 删除 `C:\Users\你的用户名\.flutter` 目录

---

## 有用的资源

- Flutter官方文档: https://docs.flutter.dev/
- Flutter中文网: https://flutter.cn/
- Dart语言教程: https://dart.dev/guides
- Flutter示例: https://flutter.github.io/samples/

---

祝你使用愉快！如有问题，请参考Flutter官方文档或社区。
