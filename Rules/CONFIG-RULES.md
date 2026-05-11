# Config Rules

## 目标

所有 app 级差异项必须从配置层进入，而不是散落在页面、Store、Repository 中。

## 当前配置入口

1. `AppConfig`
2. `SupportConfig`
3. `LegalConfig`
4. `SubscriptionConfig`

## 必须进入配置层的内容

1. App 名称
2. Bundle ID
3. API Base URL
4. App Store ID
5. Share URL
6. Support Email
7. Terms URL
8. Privacy URL
9. Product IDs
10. 默认订阅方案

## 禁止

1. 把产品 ID 写死在 paywall 页面
2. 把邮箱写死在 feedback 逻辑里
3. 把法务 URL 写死在 use case 里
4. 把 bundle 信息手工写死在设置页里
