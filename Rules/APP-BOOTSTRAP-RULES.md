# App Bootstrap Rules

## Scope

适用于 `StarterApp/App/` 下的入口、组合根、根环境和根视图。

## Goal

让 App 启动链路保持薄、稳定、可替换，避免依赖创建散落到页面里。

## Standard Shape

```text
App/
├── StarterApp.swift
├── AppContainer.swift
├── AppEnvironment.swift
└── AppRootView.swift
```

## Rules

- `@main` 默认位于 `StarterApp/App/StarterApp.swift`。
- `StarterApp` 只创建根 `Scene`，不装配业务依赖。
- `AppContainer` 统一创建配置、Repository、UseCase、Store 和全局对象。
- `AppEnvironment` 只暴露根级共享对象，不放业务计算。
- `AppRootView` 只承接 Tab、根导航、全局浮层和根级 sheet / full screen cover。
- 启动阶段不能被订阅、网络、远程配置等可失败能力阻塞。
- 新增全局依赖时先改 `AppContainer`，再决定是否进入 `AppEnvironment`。

## Avoid

- 在根视图里直接 `new` Repository、UseCase 或 SDK 实现。
- 在 Feature 页面里创建全局单例。
- 让启动链路依赖真实网络结果。
- 把一次性迁移、缓存清理、订阅刷新写成阻塞启动的同步流程。

## Checklist

- 入口文件是否仍是唯一 `@main`。
- App 依赖是否只在组合根创建。
- 根视图是否没有外部能力实现细节。
- 启动失败是否不会导致整 App 空白或崩溃。
