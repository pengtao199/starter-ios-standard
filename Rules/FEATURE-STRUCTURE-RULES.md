# Feature Structure Rules

## Scope

适用于 `StarterApp/Features/<Feature>/` 的新建、扩展和重构。

## Goal

每个 Feature 先建立最小可运行主链路，再按真实依赖补齐应用层、领域层和基础设施层。

## Standard Shape

```text
Features/<Feature>/
├── Presentation/
├── Application/
├── Domain/
└── Infrastructure/
```

## Rules

- Feature 名使用 `PascalCase`。
- 最小起手文件为 `<Feature>View.swift`、`<Feature>Store.swift`、一个明确动作的 `UseCase`、一个业务模型文件。
- `Presentation` 先跑通页面状态和用户动作。
- `Application` 只在存在明确业务动作时新增 UseCase。
- `Domain` 只在模型、协议或规则需要跨 UI 复用时新增。
- `Infrastructure` 只在出现真实数据访问、系统能力或 SDK 依赖时新增。
- Feature 私有组件优先留在本 Feature；两个以上 Feature 稳定复用后再考虑上移到 `Common`。

## Avoid

- 一开始就生成全套空目录和空协议。
- 用 `Helper / Utils / Manager` 承载不清晰职责。
- Feature 之间直接互相引用对方的 `Presentation`。
- 把业务 Feature 的配置写进全局 `Config`，除非它确实是 app 级差异。

## Checklist

- Feature 是否有清晰用户路径。
- 新文件是否围绕真实动作产生。
- Store 是否只暴露页面需要的状态和意图。
- 依赖是否沿 `Store -> UseCase -> Protocol -> Implementation` 进入。
