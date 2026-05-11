# Config Rules

## Scope

适用于 `StarterApp/Config/` 以及所有读取 app 级差异项的代码。

## Goal

所有 app 级差异项必须从配置层进入，而不是散落在页面、Store、UseCase 或 Repository 中。

## Config Entrypoints

- `AppConfig`
- `SupportConfig`
- `LegalConfig`
- `SubscriptionConfig`

## Rules

- App 名称、Bundle ID、版本号、API Base URL 归 `AppConfig`。
- App Store ID、分享 URL、客服邮箱归 `SupportConfig`。
- Terms URL、Privacy URL 归 `LegalConfig`。
- 订阅产品 ID、默认方案、付费页展示配置归 `SubscriptionConfig`。
- 新增配置先判断是 app 级差异还是运行时状态；运行时状态不得塞进 `Config/`。
- 配置必须通过组合根注入到 UseCase、Repository 或 Store。
- `Tools/reset_project.rb` 能改到的项目差异，优先保持在配置文件或本地化文件中。

## Avoid

- 把产品 ID 写死在 paywall 页面。
- 把邮箱写死在 feedback 逻辑里。
- 把法务 URL 写死在 UseCase 里。
- 把 Bundle 信息手工写死在设置页里。
- 为单个临时实验添加长期配置项。

## Checklist

- 新 app 差异是否能只改 `Config/` 和本地化完成。
- 配置值是否有明确归属文件。
- 页面中是否没有硬编码 URL、邮箱、产品 ID。
