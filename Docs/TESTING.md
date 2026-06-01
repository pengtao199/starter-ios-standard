# Starter iOS Standard - 完整测试指南

## 第一步：复制项目到临时目录

```bash
# 在任意目录运行（比如 Desktop）
cd ~/Desktop

# 克隆远程项目
git clone -b agents/greeting-response https://github.com/pengtao199/starter-ios-standard.git test-starter

# 进入项目
cd test-starter
```

## 第二步：验证基座本身能运行

```bash
# 直接打开工程
open StarterApp.xcodeproj
```

**Xcode 中验证**：
- [ ] 工程能编译 (⌘B)
- [ ] Home tab 能启动和显示
- [ ] Settings tab 正常
- [ ] 可以打开 Subscription 页
- [ ] 可以打开 Legal 页

## 第三步：测试 reset 脚本

```bash
# 查看脚本帮助
ruby Tools/reset_project.rb --help

# 运行脚本初始化新项目（以"番茄专注"为例）
ruby Tools/reset_project.rb \
  --owner "Your Company" \
  --product-name "番茄专注" \
  --bundle-id "com.company.focus" \
  --module-name "FocusApp"
```

**脚本会输出类似**：
```
✅ Reset complete!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Configuration:
  Owner:     Your Company
  Product:   番茄专注
  Bundle ID: com.company.focus
  Module:    FocusApp
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⚠️  Manual steps required:
1. UPDATE ROOT README.md ...
2. UPDATE DOCUMENTATION IF NEEDED ...
3. VERIFY XCODE PROJECT ...
4. CLEAN & BUILD ...

5. ✅ Cleanup
   This reset script has been automatically deleted.

Happy coding! 🚀
```

## 第四步：验证脚本改动

运行脚本后，检查以下是否正确改名了：

```bash
# 1. 检查目录名（应该从 StarterApp 变成 FocusApp）
ls -la | grep FocusApp

# 2. 检查工程名（应该从 StarterApp.xcodeproj 变成 FocusApp.xcodeproj）
ls -la | grep FocusApp.xcodeproj

# 3. 检查脚本是否自动删除
ls -la Tools/
# 应该只有 Tools 目录本身，没有 reset_project.rb

# 4. 检查配置文件是否更新
cat .starter-project.json | grep bundle_id
# 应该看到 "com.company.focus"

# 5. 检查 Swift 文件是否被重命名
ls FocusApp/App/
# 应该看到 FocusApp.swift（而不是 StarterApp.swift）
```

## 第五步：验证新工程能编译

```bash
# 打开新工程
open FocusApp.xcodeproj

# 在 Xcode 中编译 (⌘B)
```

**验证清单**：
- [ ] 能编译成功
- [ ] Bundle ID 是 com.company.focus
- [ ] App 名是 番茄专注
- [ ] Home / Settings 正常启动
- [ ] 文档中的路径已更新（对比 README.md 中的 FocusApp/ 引用）

## 第六步：验证新增文件自动识别

```bash
# 在 FocusApp 里新增一个测试文件
cat > FocusApp/Test.swift << 'SWIFT'
import Foundation

// Test file to verify Xcode auto-recognition
print("Hello from test file")
SWIFT

# 打开工程
open FocusApp.xcodeproj
```

**在 Xcode 中**：
- [ ] Xcode 项目导航栏能看到 Test.swift
- [ ] Build (⌘B) 能通过编译
- [ ] 编译成功说明 Xcode 自动识别了新文件

## 测试完成清理

```bash
# 删除临时测试目录
cd ~/Desktop
rm -rf test-starter

# 或者保留做参考
```

## 常见问题排查

### Q1: 脚本报错 "Missing source directory"
**A**: 确保在正确的项目目录下运行脚本

### Q2: 脚本运行后没有删除自己
**A**: 检查权限 `ls -la Tools/` 中脚本是否有执行权限

### Q3: Xcode 打开新工程后 target 名还是 StarterApp
**A**: 这是正常的，需要手动改（Project → Target → Display Name）

### Q4: Build 失败
**A**: Clean build folder (⌘⇧K) 后重试

