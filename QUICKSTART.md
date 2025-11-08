# 快速开始指南

## Windows开发完整教程（5分钟上手）

### 第一步：安装Flutter（首次使用需要）

如果你还没有安装Flutter，按照以下步骤：

1. **下载Flutter**
   - 访问: https://docs.flutter.dev/get-started/install/windows
   - 下载Flutter SDK ZIP文件
   - 解压到 `C:\src\flutter` （推荐路径）

2. **配置环境变量**
   - 右键"此电脑" > 属性 > 高级系统设置 > 环境变量
   - 在"Path"中添加: `C:\src\flutter\bin`
   - 点击确定

3. **验证安装**
   ```powershell
   # 打开PowerShell或CMD
   flutter doctor
   ```

4. **安装Android Studio**（用于Android测试）
   - 下载: https://developer.android.com/studio
   - 安装后打开，安装Android SDK
   - 创建一个Android虚拟设备（AVD）

---

### 第二步：运行项目

```powershell
# 1. 进入项目目录
cd E:\IOSDATA\LocationDetectorFlutter

# 2. 获取依赖
flutter pub get

# 3. 检查可用设备
flutter devices

# 4. 启动Android模拟器（如果还没启动）
# 在Android Studio中: Tools > Device Manager > 启动模拟器

# 5. 运行应用
flutter run
```

等待编译完成（首次可能需要5-10分钟），应用会自动安装到模拟器并运行！

---

### 第三步：开发和测试

**热重载**: 修改代码后，在终端按 `r` 即可实时看到效果，无需重新编译！

**常用命令**:
- 按 `r`: 热重载
- 按 `R`: 热重启（完全重启应用）
- 按 `q`: 退出
- 按 `h`: 查看帮助

---

### 第四步：打包iOS应用（无需Mac！）

#### 方法A：使用Codemagic（推荐）

**1. 创建GitHub仓库并上传代码**

```powershell
cd E:\IOSDATA\LocationDetectorFlutter

# 初始化git
git init

# 添加所有文件
git add .

# 提交
git commit -m "Initial commit"

# 连接到你的GitHub仓库（先在GitHub网站创建空仓库）
git remote add origin https://github.com/你的用户名/location-detector.git

# 推送
git push -u origin main
```

**2. 设置Codemagic**

1. 访问 https://codemagic.io/
2. 用GitHub账号登录
3. 点击 "Add application"
4. 选择刚创建的仓库
5. Codemagic会自动检测到配置

**3. 修改邮箱配置**

编辑 `codemagic.yaml` 文件，将所有 `your-email@example.com` 改为你的真实邮箱。

**4. 开始构建**

1. 在Codemagic中选择工作流:
   - `all-platforms`: 同时构建iOS和Android（推荐）
   - `ios-workflow`: 仅iOS
   - `android-workflow`: 仅Android

2. 点击 "Start new build"

3. 等待15-20分钟

4. 构建完成后，会发送下载链接到你的邮箱

**5. 下载和安装**
- **Android APK**: 可以直接安装到Android手机
- **iOS .app**: 需要通过以下方式之一安装:
  - 使用Xcode安装到iPhone（需要借用Mac）
  - 配置TestFlight分发
  - 使用云Mac服务安装

---

#### 方法B：使用GitHub Actions（备选）

1. 在项目中创建 `.github/workflows/build.yml`（已在README中提供示例）
2. 推送到GitHub
3. 在GitHub的Actions标签页查看构建进度
4. 下载构建产物

---

### 第五步：连接真实设备测试

#### Android设备

1. 在手机上启用开发者选项:
   - 设置 > 关于手机 > 连续点击"版本号"7次
   - 返回 > 开发者选项 > 启用"USB调试"

2. 用USB连接手机到电脑

3. 手机上点击"允许USB调试"

4. 运行:
   ```bash
   flutter devices  # 确认手机已识别
   flutter run      # 应用会安装到手机
   ```

#### iOS设备（需要Mac或云服务）

如果有Mac:
```bash
# 连接iPhone到Mac
flutter devices
flutter run
```

如果没有Mac:
- 使用Codemagic构建，通过TestFlight安装
- 或使用云Mac服务（MacinCloud等）

---

## 常见问题快速解决

### Q: `flutter doctor` 显示错误
**A**: 根据提示安装缺失的组件，最重要的是Android Studio和Android SDK。

### Q: 找不到设备
**A**:
```bash
# 启动Android模拟器
# 在Android Studio: Tools > Device Manager > Play按钮

# 或使用命令
flutter emulators
flutter emulators --launch <emulator_name>
```

### Q: 编译错误
**A**:
```bash
flutter clean
flutter pub get
flutter run
```

### Q: iOS构建失败
**A**: 检查 `codemagic.yaml` 配置，确保使用的是最新的Flutter版本。

### Q: 应用闪退
**A**:
- 检查权限是否授予（位置、蓝牙）
- 查看日志: `flutter logs`

---

## 下一步学习

- 修改UI: 编辑 `lib/screens/home_screen.dart`
- 修改业务逻辑: 编辑 `lib/services/location_service.dart`
- 学习Flutter: https://docs.flutter.dev/
- 学习Dart: https://dart.dev/guides

---

## 获取帮助

- Flutter官方文档: https://docs.flutter.dev/
- Codemagic文档: https://docs.codemagic.io/
- 项目完整说明: 查看 README.md

---

祝开发愉快！🚀
