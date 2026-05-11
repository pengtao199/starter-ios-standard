# Architecture Rules

## 官方模式

`Feature-First Clean-ish Architecture with SwiftUI Store-based Presentation`

## 目录约束

```text
StarterApp/
├── App/
├── Features/
├── Core/
├── Common/
├── Config/
└── Resources/
```

## 分层约束

1. `App` 只做组合根
2. `Presentation` 只放 `View / Store`
3. `Application` 只放 `UseCase / Coordinator`
4. `Domain` 只放协议、模型、规则
5. `Infrastructure / Integrations` 只做外部能力实现

## 拒绝项

1. 页面层直接接网络
2. Store 直接持有 SDK 实现
3. 把 app 级配置写死在页面里
