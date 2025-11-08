# LocationDetector - 定位设备检测器（Flutter版）

一个使用Flutter开发的跨平台应用，可以检测外部GPS定位设备并显示当前位置坐标信息。

**支持平台**: iOS 15+ / iPadOS 17+ / Android 5.0+

---

## 功能特性

- ✅ 检测外部GPS定位设备（蓝牙GPS、外部附件等）
- 📍 显示当前位置的经纬度坐标
- 📏 显示定位精度信息
- 🎯 现代化的Material Design界面
- 🚀 一套代码同时支持iOS和Android
- ☁️ 使用Codemagic云端自动打包iOS和Android应用

---

## 项目结构

```
LocationDetectorFlutter/
├── lib/
│   ├── main.dart                    # 应用入口
│   ├── screens/
│   │   └── home_screen.dart         # 主界面UI
│   └── services/
│       └── location_service.dart    # 定位和设备检测服务
├── android/
│   └── app/
│       ├── src/main/AndroidManifest.xml  # Android权限配置
│       └── build.gradle             # Android构建配置
├── ios/
│   └── Runner/
│       └── Info.plist               # iOS权限配置
├── pubspec.yaml                     # Flutter依赖配置
├── codemagic.yaml                   # Codemagic自动构建配置
└── README.md                        # 本文件
```

---

## 在Windows上开发（完整指南）

### 第一步：安装Flutter

1. **下载Flutter SDK**
   - 访问: https://docs.flutter.dev/get-started/install/windows
   - 下载Flutter SDK压缩包
   - 解压到 `C:\flutter` 或其他目录

2. **配置环境变量**
   ```powershell
   # 添加到系统Path
   C:\flutter\bin
   ```

3. **验证安装**
   ```bash
   flutter doctor
   ```

4. **安装Android Studio**（用于Android开发和模拟器）
   - 下载: https://developer.android.com/studio
   - 安装Android SDK和模拟器
   - 在Flutter中配置:
     ```bash
     flutter config --android-studio-dir="C:\Program Files\Android\Android Studio"
     ```

### 第二步：打开项目

```bash
cd E:\IOSDATA\LocationDetectorFlutter
flutter pub get
```

### 第三步：在Windows上运行和测试

**选项1: 使用Android模拟器（推荐）**

```bash
# 启动模拟器
flutter emulators --launch <emulator_id>

# 运行应用
flutter run
```

**选项2: 连接Android真机**

1. 在Android设备上启用开发者选项和USB调试
2. 用USB连接到电脑
3. 运行:
   ```bash
   flutter devices
   flutter run
   ```

**选项3: 使用Windows桌面模式（仅UI测试）**

```bash
flutter run -d windows
```

⚠️ **注意**: Windows版本可以测试UI，但GPS功能需要在真实移动设备上测试。

### 第四步：开发和调试

```bash
# 热重载（修改代码后自动刷新）
flutter run
# 然后在终端按 'r' 热重载，按 'R' 热重启

# 查看日志
flutter logs

# 检查代码问题
flutter analyze
```

---

## 使用Codemagic自动打包iOS应用（无需Mac！）

### 方法一：使用Codemagic（推荐，免费）

**步骤**:

1. **创建GitHub仓库**
   ```bash
   cd E:\IOSDATA\LocationDetectorFlutter
   git init
   git add .
   git commit -m "Initial commit"
   git remote add origin <你的GitHub仓库URL>
   git push -u origin main
   ```

2. **注册Codemagic账号**
   - 访问: https://codemagic.io/
   - 使用GitHub账号登录
   - 免费套餐: 每月500分钟构建时间

3. **连接仓库**
   - 在Codemagic中点击 "Add application"
   - 选择你的GitHub仓库
   - Codemagic会自动检测到 `codemagic.yaml` 配置

4. **配置构建**
   - 选择工作流: `all-platforms` (同时构建iOS和Android)
   - 或者选择 `ios-workflow` (仅iOS) 或 `android-workflow` (仅Android)

5. **修改配置文件中的邮箱**
   - 编辑 `codemagic.yaml`
   - 将 `your-email@example.com` 改为你的邮箱

6. **开始构建**
   - 点击 "Start new build"
   - 等待10-20分钟
   - 构建完成后会发送下载链接到你的邮箱

7. **下载应用**
   - iOS: 下载 `.app` 文件（需要Mac安装）或配置TestFlight
   - Android: 下载 `.apk` 文件（可直接安装到Android设备）

### iOS应用签名（如需安装到真实设备）

**选项1: 使用Apple开发者账号**
- 在Codemagic中配置代码签名证书
- 文档: https://docs.codemagic.io/yaml-code-signing/signing-ios/

**选项2: 临时测试（无需付费账号）**
- 使用Codemagic的免费代码签名
- 应用可在测试设备上运行7天

### 方法二：使用GitHub Actions

项目中也可以配置GitHub Actions实现自动构建，配置文件示例:

创建 `.github/workflows/build.yml`:

```yaml
name: Build iOS & Android

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: macos-latest

    steps:
      - uses: actions/checkout@v3

      - name: 设置Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'

      - name: 安装依赖
        run: flutter pub get

      - name: 构建Android APK
        run: flutter build apk --release

      - name: 构建iOS（无签名）
        run: flutter build ios --release --no-codesign

      - name: 上传APK
        uses: actions/upload-artifact@v3
        with:
          name: android-apk
          path: build/app/outputs/flutter-apk/app-release.apk
```

---

## 本地开发命令速查

```bash
# 获取依赖
flutter pub get

# 运行应用（开发模式）
flutter run

# 运行在特定设备
flutter run -d <device_id>

# 构建Android APK
flutter build apk --release

# 构建Android App Bundle
flutter build appbundle --release

# 构建iOS（需要Mac）
flutter build ios --release

# 清理构建缓存
flutter clean

# 检查环境
flutter doctor

# 查看可用设备
flutter devices

# 查看可用模拟器
flutter emulators

# 升级Flutter
flutter upgrade
```

---

## 应用使用说明

1. **安装应用**
   - Android: 直接安装APK
   - iOS: 需要通过Xcode或TestFlight安装

2. **授予权限**
   - 首次打开会请求位置权限，点击"允许"
   - 如需检测蓝牙GPS设备，还需授予蓝牙权限

3. **检测位置**
   - 点击"检测"按钮
   - 等待几秒获取GPS信号
   - 查看结果展示区

4. **结果说明**
   - **外部定位设备状态**: 是否连接了外部GPS设备
   - **纬度/经度**: 当前位置坐标
   - **精度**: 定位精度（数值越小越准确）

---

## 外部GPS设备检测原理

### iOS平台
- 通过蓝牙检测连接的GPS设备
- 检测设备名称中的GPS关键词
- 支持MFi认证的外部GPS设备

### Android平台
- 检测蓝牙连接的GPS设备
- 识别GPS相关的设备名称
- 支持蓝牙GNSS接收器

### 检测条件
设备名称包含以下关键词会被识别为GPS设备:
- `gps`
- `gnss`
- `location`
- `navigator`

---

## 常见问题

### Q1: 在Windows上能测试完整功能吗？
A: 可以测试UI和基本流程，但GPS定位功能需要在真实移动设备（Android手机或模拟器）上测试。

### Q2: 不使用Mac能打包iOS应用吗？
A: 可以！使用Codemagic或GitHub Actions云端构建服务，完全不需要Mac。

### Q3: Codemagic免费吗？
A: 有免费套餐，每月500分钟构建时间，对于个人项目足够使用。

### Q4: 如何在真实iPhone上测试？
A:
- 方法1: 使用Codemagic构建并通过TestFlight分发
- 方法2: 借用Mac进行本地打包安装
- 方法3: 使用云Mac服务（如MacinCloud）

### Q5: Android版本需要什么系统版本？
A: Android 5.0 (API 21) 及以上。

### Q6: 为什么检测不到外部GPS设备？
A:
- 确保设备通过蓝牙连接
- 检查蓝牙权限是否授予
- 确认设备名称包含GPS相关关键词

---

## 依赖说明

主要使用的Flutter插件:

- **geolocator**: GPS定位服务
- **permission_handler**: 权限管理
- **provider**: 状态管理
- **flutter_blue_plus**: 蓝牙设备检测

---

## 技术栈

- **框架**: Flutter 3.0+
- **语言**: Dart
- **状态管理**: Provider
- **UI**: Material Design 3
- **CI/CD**: Codemagic / GitHub Actions

---

## 开发环境要求

### Windows开发
- Windows 10/11
- Flutter SDK 3.0+
- Android Studio (可选但推荐)
- Git
- 8GB+ RAM

### Android测试
- Android模拟器 或 真实Android设备
- Android 5.0+

### iOS打包（云端）
- GitHub账号
- Codemagic账号（免费）

---

## 下一步

### 在Windows上立即开始开发:

```bash
# 1. 进入项目目录
cd E:\IOSDATA\LocationDetectorFlutter

# 2. 安装依赖
flutter pub get

# 3. 检查环境
flutter doctor

# 4. 运行应用（连接Android设备或启动模拟器）
flutter run
```

### 云端打包iOS应用:

1. 将代码推送到GitHub
2. 在Codemagic中连接仓库
3. 点击构建
4. 等待邮件通知下载应用

---

## 许可证

本项目仅供学习和参考使用。

---

## 支持

如有问题，请参考:
- [Flutter官方文档](https://docs.flutter.dev/)
- [Codemagic文档](https://docs.codemagic.io/)
- [Geolocator插件文档](https://pub.dev/packages/geolocator)

---

Generated with Claude Code
