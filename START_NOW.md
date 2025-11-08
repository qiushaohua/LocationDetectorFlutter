# 🚀 立即开始 - 最快安装方式（3分钟手动安装）

## ⚡ 快速安装步骤

### 第1步：下载Flutter SDK（2分钟）

**点击下载（直接链接）**:
```
https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.16.9-stable.zip
```

或访问官网：
```
https://docs.flutter.dev/get-started/install/windows
```

**下载大小**: 约800MB

---

### 第2步：解压到指定位置（30秒）

将下载的zip文件解压到：
```
C:\src\flutter
```

**结果应该是**:
```
C:\src\flutter\bin\
C:\src\flutter\packages\
...
```

---

### 第3步：配置环境变量（30秒）

**方法A：PowerShell命令**（推荐）

以**管理员身份**打开PowerShell，运行：
```powershell
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\src\flutter\bin", "User")
```

**方法B：图形界面**

1. 右键"此电脑" → 属性
2. 高级系统设置 → 环境变量
3. 用户变量 → 找到"Path" → 编辑
4. 点击"新建"
5. 输入：`C:\src\flutter\bin`
6. 点击"确定"保存

---

### 第4步：验证安装（10秒）

**关闭当前终端，重新打开新的PowerShell或CMD**，运行：
```powershell
flutter --version
```

**应该看到**:
```
Flutter 3.16.9 • channel stable
```

---

### 第5步：运行项目（30秒）

```powershell
cd E:\IOSDATA\LocationDetectorFlutter
flutter pub get
flutter run -d windows
```

---

## 🎯 完整命令序列（复制粘贴）

```powershell
# 1. 配置环境变量（以管理员身份运行PowerShell）
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\src\flutter\bin", "User")

# 2. 关闭并重新打开PowerShell，然后运行：
cd E:\IOSDATA\LocationDetectorFlutter
flutter pub get
flutter run -d windows
```

---

## ⏱️ 时间线

```
00:00 - 开始下载Flutter SDK
02:00 - 下载完成，开始解压
02:30 - 解压完成，配置环境变量
03:00 - 验证安装
03:30 - 运行项目
08:30 - 首次编译完成，应用启动！
```

---

## 📥 快速下载链接

### 官方下载（推荐）:
```
https://docs.flutter.dev/get-started/install/windows
```

### 直接下载链接:
```
https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.16.9-stable.zip
```

### 国内镜像（中国用户）:
```
https://storage.flutter-io.cn/flutter_infra_release/releases/stable/windows/flutter_windows_3.16.9-stable.zip
```

---

## ✅ 检查清单

安装前：
- [ ] 确保有至少2GB磁盘空间（C盘）
- [ ] 有管理员权限
- [ ] 网络连接正常

安装中：
- [ ] 下载flutter_windows_xxx-stable.zip
- [ ] 解压到C:\src\flutter
- [ ] 添加环境变量
- [ ] 验证flutter --version

安装后：
- [ ] 关闭并重新打开终端
- [ ] 运行flutter pub get
- [ ] 运行flutter run -d windows

---

## 🆘 遇到问题？

### 问题1：下载速度慢
**解决**: 使用国内镜像或挂梯子

### 问题2：flutter命令找不到
**解决**:
1. 确认解压到了C:\src\flutter
2. 确认环境变量已添加
3. **关闭并重新打开终端**

### 问题3：权限不足
**解决**: 右键PowerShell → "以管理员身份运行"

---

## 🎊 立即开始

**现在就做**:

1. 🔗 **点击下载**: https://docs.flutter.dev/get-started/install/windows
2. 📦 **解压到**: C:\src\flutter
3. ⚙️ **配置环境变量**（见第3步）
4. ✅ **验证**: flutter --version
5. ▶️ **运行**: cd E:\IOSDATA\LocationDetectorFlutter && flutter run -d windows

**预计3分钟完成安装，5分钟后应用运行！**

---

## 🚀 最快路径

```
下载 → 解压 → 配置 → 运行
2分钟   30秒   30秒   5分钟
```

**开始下载**: https://docs.flutter.dev/get-started/install/windows

**下载完成后，按照上述步骤操作即可！** 🎉
