# Starter iOS 全局规则

更新时间：2026-04-23（Asia/Shanghai）

本目录规则服务于 `starter-ios-standard`，用于指导后续通用 Starter 的继续演进。

## 1. 核心目标

1. 让新 iOS 项目在最短时间内获得可运行基座
2. 保持模块通用，避免业务语义污染
3. 所有 app 级差异项都从配置层进入

## 2. 读取顺序（强制）

每次开始处理 Starter 任务，按以下顺序读取：

1. 本文件 `Rules/AGENTS.md`
2. `Docs/DEVELOPMENT-ORDER.md`
3. 按任务命中补读：
   - 架构：`ARCHITECTURE-RULES.md`
   - App 启动：`APP-BOOTSTRAP-RULES.md`
   - Feature 起手：`FEATURE-TEMPLATE-RULES.md`
   - 状态模型：`STATE-MODEL-RULES.md`
   - 网络：`NETWORK-RULES.md`
   - 命名：`NAMING-RULES.md`
   - 本地化：`LOCALIZATION-RULES.md`
   - 配置：`CONFIG-RULES.md`
   - 设置/订阅：`SETTINGS-SUBSCRIPTION-RULES.md`

## 3. 工作原则

1. 先规则后实现
2. 先参数化后复用
3. 先做 Standard 主战模板，再演进 Lite / Pro
4. 先改配置，再改业务页面
5. 先收口系统页面，再做业务 Feature

## 4. 默认交付物

Starter 目录内的变更默认要同步考虑：

1. 源码
2. 规则文档
3. 模板
4. Skill 规格

## 5. 新项目上手顺序（强制）

当一个新 app 基于 Starter 起步时，默认顺序固定为：

1. 先改 `Config/`
2. 先验证 `Settings / Support / Legal / Subscription`
3. 再创建第一个真实业务 Feature
4. 再接网络和真实接口
5. 最后才补缓存、下载、媒体、广告等可选能力

禁止顺序：

1. 一上来先删系统页面
2. 一上来先接重媒体能力
3. 一上来先把配置散落进页面

## 6. 规则边界

1. `Rules/` 只定义 Starter 的通用规则
2. 具体新 app 的业务规则应在复制出去后的项目内维护
3. 本目录的规则不承载具体业务 API 设计
