# Settings And Subscription Rules

## Settings 规则

Starter 默认把 `Settings` 当成一级系统页面，而不是附属页面。

默认包含：

1. Appearance
2. Language
3. Subscription 入口
4. Rate App
5. Share App
6. Feedback
7. Legal
8. App Name / Version

规则：

1. 新项目优先先收口 Settings，再做业务首页
2. 所有 support 动作统一走 repository / use case
3. 没有真实缓存能力时，清缓存可以保留为 noop 能力

## Subscription 规则

Starter 默认采用：

1. `StoreKit 2`
2. `SubscriptionStoreKitRepositoryProtocol`
3. `SubscriptionStateRepositoryProtocol`
4. `SubscriptionStore`
5. `SubscriptionView`

规则：

1. 产品 ID 必须来自 `SubscriptionConfig`
2. 没有真实产品配置时，订阅页必须进入受控占位/失败态
3. 订阅失败不得阻塞整个 App 启动
4. 恢复购买、法务入口必须是付费页默认组成部分
