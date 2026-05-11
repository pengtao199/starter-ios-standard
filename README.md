# Starter iOS Standard

`starter-ios-standard` 是一个可运行的通用 iOS 项目基座工作区。

它的定位不是 FYPIX 的业务子模块，而是一个在 FYPIX 仓库中孵化的 `Standard 档 Starter`，用于后续快速复制出新的 iOS 项目。

## 当前已内置

1. `App Shell`
2. `Overlay Kit`
3. `Page State Kit`
4. `Settings + Support + Legal`
5. `Preferences`
6. `Subscription`
7. `Network Baseline`
8. `Rules / Templates / Skill Draft`

## 目录入口

1. `StarterApp/`
   这里是实际可运行的 Xcode 工程源码。
2. `StarterApp.xcodeproj`
   生成后的工程文件。
3. `Rules/`
   Starter 的开发规则入口。
4. `Docs/`
   架构说明、上手顺序、使用文档。
5. `SkillSpec/`
   Starter skill 的规格书和草案。
6. `Templates/`
   后续生成新 Feature / Page / Paywall 的模板入口。
7. `Tools/generate_project.rb`
   用于重新生成 `StarterApp.xcodeproj`。

## 先读什么

推荐进入顺序：

1. 先读 [Rules/AGENTS.md](/Users/mac/Documents/FYPIX/starter-ios-standard/Rules/AGENTS.md)
2. 再读 [Docs/README.md](/Users/mac/Documents/FYPIX/starter-ios-standard/Docs/README.md)
3. 再读 [Docs/DEVELOPMENT-ORDER.md](/Users/mac/Documents/FYPIX/starter-ios-standard/Docs/DEVELOPMENT-ORDER.md)
4. 按任务补读 `Rules/` 下专项规则

## 上手后的开发顺序

如果你把这套 Starter 复制成一个新项目，建议按这个顺序开工：

1. 先改配置，不先改页面
2. 先让 Settings / Legal / Support / Subscription 跑通
3. 再创建第一个业务 Feature
4. 再接入网络和真实接口
5. 最后才补缓存、下载、媒体等可选能力

更详细的执行顺序见：

[DEVELOPMENT-ORDER.md](/Users/mac/Documents/FYPIX/starter-ios-standard/Docs/DEVELOPMENT-ORDER.md)

## 重新生成工程

```bash
ruby Tools/generate_project.rb
```

然后打开：

```text
StarterApp.xcodeproj
```

## 当前不包含

1. 媒体缓存
2. Live Photo
3. 重下载链路
4. 广告
5. 本机已安装 skill

这些能力保留为后续 Lite / Pro 演进位。
