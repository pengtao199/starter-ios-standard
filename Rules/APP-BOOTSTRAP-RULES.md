# App Bootstrap Rules

## 标准结构

```text
App/
├── StarterApp.swift
├── AppContainer.swift
├── AppEnvironment.swift
└── AppRootView.swift
```

## 规则

1. `StarterApp` 只创建根 scene
2. `AppContainer` 统一创建依赖
3. `AppEnvironment` 暴露根级共享对象
4. `AppRootView` 承接 Tab、根导航、全局浮层

## 禁止

1. 在根视图里 new 具体实现
2. 依赖创建分散到各个页面
