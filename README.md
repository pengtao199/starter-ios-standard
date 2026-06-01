# Starter iOS Standard

`starter-ios-standard` 是一套可运行、可复制、可重置的通用 iOS Standard 基座。

它的目标是让新 iOS 项目先拥有稳定的 App Shell、系统页、配置层、订阅入口、网络基线和合规基线，再开始承载具体业务。

## 内置能力

1. App Shell
2. Overlay Kit
3. Page State Kit
4. Settings / Support / Legal
5. Preferences
6. Subscription
7. Network Baseline
8. Privacy Manifest / App Store Compliance Baseline
9. Rules / Templates / Plans

## 目录入口

1. `StarterApp/`
   实际可运行的 SwiftUI 源码。
2. `StarterApp.xcodeproj`
   生成后的 Xcode 工程。
3. `AGENTS.md`
   根级开发规则入口。
4. `Rules/`
   专项开发规则，只放长期约束。
5. `Docs/`
   项目说明、PRD、参考资料和非规则类文档。
6. `Plans/`
   阶段计划、执行方案和决策记录。
7. `Templates/`
   Feature / Page / Paywall 起手模板。
8. `Tools/generate_project.rb`
   重新生成 Xcode 工程。
9. `Tools/reset_project.rb`
   将基座重置成新项目。

## 推荐阅读顺序

1. 先读 `AGENTS.md`
2. 再按任务读取命中的 `Rules/*.md`
3. 需要产品说明、PRD 或参考材料时读取 `Docs/`
4. 需要执行阶段计划时读取 `Plans/`
5. 需要创建模块时读取 `Templates/`

## 本地运行

直接打开工程：

```bash
open StarterApp.xcodeproj
```

然后验证：

1. 工程能编译、能启动
2. `Home / Settings` 两个 root tab 正常
3. 外观、语言、订阅页入口、法务页入口能打开
4. `PrivacyInfo.xcprivacy` 被打进 app target

## 新增文件

新增 `.swift` 文件后，在 Xcode 中：
1. 将文件拖到工程树（或用 File → Add Files）
2. 确保勾选了 app target
3. 文件会自动加入 build phase

## 重新生成工程

如果需要完全重置工程结构（不推荐），运行：

```bash
ruby Tools/generate_project.rb
```

## 重置成新项目

复制这套基座后，运行：

```bash
ruby Tools/reset_project.rb \
  --owner "Your Name" \
  --product-name "Your Product" \
  --bundle-id "com.example.yourproduct"
```

脚本会自动处理：

| 项 | 自动处理 |
|----|---------|
| 源码目录名 | `StarterApp/` → `YourModule/` |
| `.xcodeproj` 文件名 | `StarterApp.xcodeproj` → `YourModule.xcodeproj` |
| Bundle ID | `co.example.starterapp` → `com.example.yourproduct` |
| App 显示名 | `Starter App` → `Your Product` |
| `AppConfig.swift` | Bundle ID、版本、API URL 等 |
| 订阅产品 ID | `*.pro.yearly` / `*.pro.monthly` |
| 本地化字符串 | App 名、标题等所有地方 |
| `Info.plist` | CFBundleDisplayName、CFBundleName |
| 文档中的路径 | `Docs/`、`Rules/`、`Plans/`、`Templates/` 内的路径引用 |

脚本完成后，**还需要手动处理**：

1. **更新 `README.md`（必须）**
   - 当前 README 是 Starter 使用说明
   - 删除本文件或改成你的 App README
   - 不要让 Starter 说明留在真实项目里

2. **检查 Xcode 工程**
   - 打开 `YourModule.xcodeproj`
   - Project → Targets → 检查 Display Name（如果还是 StarterApp，手动改过来）
   - Build & Run 验证工作

3. **检查文档准确性**
   - `Docs/`、`Rules/`、`Plans/` 中的路径名已自动更新
   - 但检查是否有其他硬编码的示例需要调整

（reset_project.rb 脚本会在运行完后自动删除）

如果产品名不是英文，建议额外传入 Swift 模块名：

```bash
ruby Tools/reset_project.rb \
  --owner "Your Name" \
  --product-name "番茄专注" \
  --bundle-id "com.example.focus" \
  --module-name "FocusApp"
```

## 新项目起手顺序

1. 先改 `Config/`
2. 先验证 `Settings / Support / Legal / Subscription`
3. 再创建第一个真实业务 Feature
4. 再接网络和真实接口
5. 同步补隐私与上架合规声明
6. 最后才补缓存、下载、媒体、广告等可选能力

## 当前不包含

1. 媒体缓存
2. Live Photo
3. 重下载链路
4. 广告
5. ATT / 广告追踪链路
6. 第三方 SDK 合规模板

这些能力保留为后续 Lite / Pro 演进位。
