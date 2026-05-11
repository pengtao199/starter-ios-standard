# Layering Contract Rules

## Scope

适用于 `StarterApp/` 下所有 Swift 代码的新建、重构和迁移。

## Goal

保持 Starter 的 `Feature-First + Store-based Presentation + Light Clean Architecture` 结构稳定，避免业务语义和外部依赖污染通用基座。

## Principles

- `App` 是唯一组合根。
- `Config` 收口 app 级差异。
- `Features` 承载用户路径。
- `Core` 承载跨 Feature 的稳定领域能力。
- `Common` 承载无业务语义的通用 UI、平台和基础类型。

## Rules

- 顶层源码目录固定为 `App / Features / Core / Common / Config / Resources`。
- 标准调用链为 `View -> Store -> UseCase -> Protocol -> Infrastructure / Integrations`。
- `Presentation` 只放 `View / Store`，只处理 UI 状态、用户意图、展示路由。
- `Application` 只放 `UseCase` 和必要的应用层协调逻辑。
- `Domain` 只放模型、协议、业务规则，禁止依赖 SwiftUI、UIKit、StoreKit 具体实现。
- `Infrastructure` 放 Feature 私有外部能力实现。
- `Integrations` 放跨 Feature 的 SDK 或系统能力实现。
- 新依赖默认在 `AppContainer` 装配，再通过 `AppEnvironment` 或 Store 初始化参数进入页面。
- 跨 Feature 复用前先确认概念稳定；不为单个 Feature 提前上移到 `Core` 或 `Common`。

## Avoid

- View 直接请求网络。
- Store 直接持有 SDK 实现。
- UseCase 直接操作 `URLSession`。
- 把产品 ID、URL、邮箱、Bundle 信息写死在页面里。
- 为未来可能出现的业务提前创建空目录和空协议。

## Checklist

- 新文件是否放在职责正确的目录。
- 调用链是否保持单向。
- 外部依赖是否通过协议或组合根进入。
- App 级差异是否先进入 `Config/`。
