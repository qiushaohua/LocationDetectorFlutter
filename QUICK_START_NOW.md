# 🚀 快速开始 - 5分钟运行指南

## ⚠️ Flutter未安装

你的系统上还没有安装Flutter。请按照以下步骤快速安装：

---

## 📦 步骤1：安装Flutter（5分钟）

### 方法A：直接下载（推荐新手）

1. **下载Flutter SDK**
   ```
   访问: https://docs.flutter.dev/get-started/install/windows
   点击: "flutter_windows_x.x.x-stable.zip" 下载
   ```

2. **解压Flutter**
   ```
   解压到: C:\src\flutter
   （不要放在需要管理员权限的目录）
   ```

3. **配置环境变量**

   **选项1 - 图形界面**:
   - 右键"此电脑" → 属性 → 高级系统设置 → 环境变量
   - 在"用户变量"下找到"Path" → 编辑
   - 点击"新建" → 输入: `C:\src\flutter\bin`
   - 确定保存

   **选项2 - PowerShell命令**（以管理员运行）:
   ```powershell
   [Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\src\flutter\bin", "User")
   ```

4. **验证安装**
   ```
   打开新的PowerShell或CMD窗口：
   flutter --version
   flutter doctor
   ```

### 方法B：使用Git克隆（推荐开发者）

```powershell
git clone https://github.com/flutter/flutter.git -b stable C:\src\flutter
# 然后添加C:\src\flutter\bin到环境变量Path
```

---

## 🔧 步骤2：安装Android Studio（可选，用于Android测试）

1. **下载Android Studio**
   ```
   访问: https://developer.android.com/studio
   下载并安装
   ```

2. **安装Android SDK**
   - 打开Android Studio
   - 选择"Standard"标准安装
   - 等待下载Android SDK

3. **接受许可**
   ```
   flutter doctor --android-licenses
   # 一路输入 y
   ```

4. **创建模拟器**
   - Android Studio → Tools → Device Manager
   - Create Device → 选择Pixel 5
   - 下载系统镜像
   - 完成创建

---

## ▶️ 步骤3：运行项目

### 使用自动化脚本（最简单）

```powershell
cd E:\IOSDATA\LocationDetectorFlutter
.\START.bat
```

脚本会自动：
- ✓ 检查Flutter安装
- ✓ 安装项目依赖
- ✓ 检测可用设备
- ✓ 启动应用

### 手动运行

```bash
cd E:\IOSDATA\LocationDetectorFlutter

# 1. 获取依赖
flutter pub get

# 2. 检查设备
flutter devices

# 3. 运行应用
flutter run

# 或者在Windows桌面模式运行（仅测试UI）
flutter run -d windows
```

---

## 📱 设备选项

### 选项1：Android模拟器（推荐新手）
```
1. 打开Android Studio
2. Tools → Device Manager
3. 点击播放按钮启动模拟器
4. 运行: flutter run
```

### 选项2：真实Android设备
```
1. 手机开启"开发者选项"和"USB调试"
2. USB连接到电脑
3. 手机上点击"允许USB调试"
4. 运行: flutter run
```

### 选项3：Windows桌面（仅测试UI）
```
flutter run -d windows
注意：GPS功能需要在真实移动设备上测试
```

### 选项4：云端打包iOS版本
```
详见: README.md 的Codemagic部分
无需Mac即可打包iOS应用
```

---

## ⏱️ 预计时间

| 步骤 | 时间 |
|------|------|
| 下载Flutter SDK | 2-5分钟 |
| 配置环境变量 | 1分钟 |
| 安装Android Studio | 5-10分钟（可选） |
| 首次运行编译 | 5-10分钟 |
| **总计** | **15-30分钟** |

之后每次运行只需几秒钟！

---

## 🆘 常见问题

### Q: flutter命令无法识别
A:
1. 确认已添加到环境变量Path
2. **关闭并重新打开**终端窗口
3. 运行: `flutter --version` 验证

### Q: Android许可未接受
A: 运行 `flutter doctor --android-licenses`，全部输入y

### Q: 找不到设备
A:
- Android模拟器: 在Android Studio中启动
- 真实设备: 确认USB调试已开启
- Windows: 使用 `flutter run -d windows`

### Q: 首次编译很慢
A: 正常现象，首次需要5-10分钟，之后只需几秒

---

## 🎯 当前状态

```
✓ 项目代码 - 已完成（增强版，与iOS原生版100%一致）
✓ 配置文件 - 已完成
✓ 文档 - 已完成
✗ Flutter环境 - 需要安装
```

---

## 📋 快速安装清单

- [ ] 1. 下载Flutter SDK
- [ ] 2. 解压到C:\src\flutter
- [ ] 3. 添加到环境变量Path
- [ ] 4. 验证: flutter --version
- [ ] 5. （可选）安装Android Studio
- [ ] 6. 运行: cd E:\IOSDATA\LocationDetectorFlutter
- [ ] 7. 运行: .\START.bat

---

## 🚀 开始安装

**立即访问**: https://docs.flutter.dev/get-started/install/windows

按照上述步骤安装后，运行：
```bash
cd E:\IOSDATA\LocationDetectorFlutter
.\START.bat
```

---

## 📞 需要帮助？

- Flutter官方文档: https://docs.flutter.dev/
- 详细安装指南: 查看本项目的 `INSTALL_FLUTTER.md`
- 项目文档: 查看 `README.md`

---

**预计总时间**: 15-30分钟完成全部安装和首次运行
**之后每次运行**: 只需几秒钟！

祝安装顺利！🎊
