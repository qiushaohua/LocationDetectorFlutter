# 🚀 立即安装Flutter - 3种方法

## ⚡ 方法1：一键自动安装（最简单）

**已为你准备好自动安装脚本！**

### 立即执行：

```powershell
# 双击运行此文件：
E:\IOSDATA\LocationDetectorFlutter\INSTALL_NOW.bat
```

或在PowerShell中运行：
```powershell
cd E:\IOSDATA\LocationDetectorFlutter
.\INSTALL_NOW.bat
```

**脚本会自动：**
- ✓ 下载Flutter SDK (约800MB)
- ✓ 解压到C:\src\flutter
- ✓ 配置环境变量
- ✓ 验证安装

**预计时间**: 5-10分钟

---

## 📦 方法2：手动快速安装

### 第1步：下载Flutter

访问Flutter官网下载最新stable版本：
```
https://docs.flutter.dev/get-started/install/windows
```

或使用直接下载链接（推荐）：
```
https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.16.9-stable.zip
```

### 第2步：解压

解压下载的zip文件到：
```
C:\src\flutter
```

### 第3步：配置环境变量

**PowerShell（推荐）** - 以管理员身份运行：
```powershell
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\src\flutter\bin", "User")
```

**或图形界面**：
1. 右键"此电脑" → 属性
2. 高级系统设置 → 环境变量
3. 用户变量 → Path → 编辑
4. 新建 → 输入：`C:\src\flutter\bin`
5. 确定保存

### 第4步：验证安装

**关闭并重新打开终端**，然后运行：
```powershell
flutter --version
flutter doctor
```

---

## 🌐 方法3：使用Git克隆（开发者推荐）

```powershell
# 1. 安装Git (如果还没有)
# 访问: https://git-scm.com/download/win

# 2. 克隆Flutter仓库
git clone https://github.com/flutter/flutter.git -b stable C:\src\flutter

# 3. 配置环境变量
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\src\flutter\bin", "User")

# 4. 验证安装（新终端）
flutter --version
```

---

## ✅ 安装后立即运行项目

安装完成后，运行以下命令启动项目：

```powershell
# 1. 进入项目目录
cd E:\IOSDATA\LocationDetectorFlutter

# 2. 获取依赖
flutter pub get

# 3. 检查设备
flutter devices

# 4. 运行应用
flutter run

# 或使用Windows桌面模式（最快）
flutter run -d windows
```

---

## 🆘 故障排除

### 问题1：flutter命令未找到

**解决**：
1. 确认环境变量已添加
2. **关闭并重新打开终端**
3. 运行：`flutter --version`

### 问题2：下载速度慢

**解决**：
使用国内镜像（中国用户）：
```powershell
$env:PUB_HOSTED_URL="https://pub.flutter-io.cn"
$env:FLUTTER_STORAGE_BASE_URL="https://storage.flutter-io.cn"
```

### 问题3：UAC权限提示

**解决**：
点击"是"允许管理员权限，这是配置环境变量所必需的。

### 问题4：解压失败

**解决**：
使用7-Zip或WinRAR手动解压到`C:\src\flutter`

---

## 📊 安装进度检查

### 1. 验证Flutter安装
```powershell
flutter --version
# 应该显示Flutter版本信息
```

### 2. 检查环境配置
```powershell
flutter doctor
# 检查开发环境配置
```

### 3. 测试项目
```powershell
cd E:\IOSDATA\LocationDetectorFlutter
flutter pub get
flutter run -d windows
```

---

## 🎯 推荐流程

**最快上手路径**：

1. ⚡ 双击运行 `INSTALL_NOW.bat`
2. ⏳ 等待5-10分钟安装完成
3. 🔄 关闭并重新打开终端
4. ▶️ 运行 `START.bat`

---

## 📱 运行选项（安装后）

### 选项A：Windows桌面（最快 - 5秒启动）
```bash
flutter run -d windows
```
✅ 适合UI测试
⚠️ GPS功能需要真实设备

### 选项B：Android模拟器（推荐）
需要Android Studio
```bash
flutter run
```
✅ 完整功能测试

### 选项C：真实设备
USB连接Android手机
```bash
flutter run
```
✅ 可测试真实GPS

---

## ⏱️ 时间预估

| 步骤 | 自动安装 | 手动安装 |
|------|---------|---------|
| 下载 | 5分钟 | 5分钟 |
| 解压 | 自动 | 2分钟 |
| 配置 | 自动 | 1分钟 |
| 验证 | 自动 | 1分钟 |
| **总计** | **5-10分钟** | **10分钟** |

---

## 🚀 立即开始

### 👉 推荐：双击运行
```
E:\IOSDATA\LocationDetectorFlutter\INSTALL_NOW.bat
```

### 或在PowerShell中：
```powershell
cd E:\IOSDATA\LocationDetectorFlutter
.\INSTALL_NOW.bat
```

**安装开始后，请在新打开的PowerShell窗口中查看进度！**

---

## 📞 需要帮助？

- Flutter官方文档: https://docs.flutter.dev/
- 项目完整文档: 查看 `INSTALL_FLUTTER.md`
- 问题排查: 查看 `README.md`

---

**准备好了吗？立即双击 `INSTALL_NOW.bat` 开始安装！** 🎊
