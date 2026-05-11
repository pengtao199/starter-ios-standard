# Naming Rules

## Scope

适用于目录、Swift 类型、文件名、本地化 key、配置项和计划文档命名。

## Goal

一个概念只保留一个 canonical name，让搜索、迁移和重置脚本都稳定可靠。

## Directory Names

- 顶层源码目录只允许 `App / Features / Core / Common / Config / Resources`。
- Feature 名使用 `PascalCase`。
- Feature 分层固定为 `Presentation / Application / Domain / Infrastructure`。
- 计划文档使用两位序号加英文大写短横线名，例如 `00-BASELINE-COMPLIANCE.md`。

## File Suffixes

- 页面：`<Name>View.swift`
- 状态源：`<Name>Store.swift`
- 动作：`<Action><Name>UseCase.swift`
- 仓储协议：`<Name>RepositoryProtocol.swift`
- 仓储实现：`<Name>Repository.swift`
- 配置：`<Name>Config.swift`
- 模型集合：`<Name>Models.swift`

## Rules

- 类型名和文件名默认一致。
- 本地化 key 使用 `feature.scope.name`。
- UseCase 名必须表达动作，例如 `LoadSettingsUseCase`、`RestoreSubscriptionPurchasesUseCase`。
- Protocol 名保留 `Protocol` 后缀，避免与实现混淆。
- 跨层同一概念使用同一词，不混用 `Premium / Pro / Subscription`。
- `Helper / Utils / Manager` 只有在职责无法进一步命名且已有本地惯例时才允许。

## Checklist

- 搜索一个概念是否只出现一套命名。
- 新文件名是否能直接看出职责。
- 是否避免了含糊的万能后缀。
- 重置脚本是否能安全替换项目名、模块名和 App 名。
