# Starter Architecture

## Overview

Starter 采用 `Feature-First + Store-based Presentation + Light Clean Architecture`。

主链路固定为：

1. `View -> Store`
2. `Store -> UseCase`
3. `UseCase -> Protocol`
4. `Infrastructure / Integrations -> Protocol`

## Directory Model

```text
StarterApp/
├── App/
├── Features/
├── Core/
├── Common/
├── Config/
└── Resources/
```

## Built-in Modules

1. Overlay Kit
2. Page State Kit
3. Settings Kit
4. Support Kit
5. Preferences Kit
6. Legal Kit
7. Subscription Kit
8. Network Kit

## Design Rules

1. App 是唯一组合根
2. Store 只管 UI 状态与用户意图
3. UseCase 只管业务动作
4. Domain 不依赖 SwiftUI / UIKit / StoreKit
5. Config 负责 app 级差异项收口
