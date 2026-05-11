# Settings And Subscription Rules

## Scope

适用于 `Settings`、Support 动作、Legal 入口、Subscription 入口和 StoreKit 订阅链路。

## Goal

把新 App 必备的系统页先稳定下来，再让业务 Feature 接入这些公共能力。

## Settings Rules

- `Settings` 是一级系统页面，不是业务页附属入口。
- 默认包含 Appearance、Language、Subscription、Rate App、Share App、Feedback、Legal、App Name / Version。
- 新项目优先收口 Settings，再做业务首页。
- Support 动作统一走 Repository / UseCase。
- 没有真实缓存能力时，清缓存可以保留为 noop 能力，但 UI 必须是可控反馈。
- Settings 读取 App 名、版本号、支持邮箱、分享链接时必须来自 Config 或 UseCase。

## Subscription Rules

- 默认采用 StoreKit 2。
- 产品 ID 必须来自 `SubscriptionConfig`。
- 订阅页默认包含 Purchase、Restore、Terms、Privacy。
- 没有真实产品配置时，订阅页必须进入受控占位或失败态。
- 订阅失败不得阻塞整个 App 启动。
- 恢复购买必须可从 Settings 和 Subscription 入口触发。
- 数字内容和高级功能默认走 StoreKit，不引导用户外部支付。

## Legal Rules

- Terms / Privacy URL 来自 `LegalConfig`。
- Settings 和 Subscription 中的法务入口必须同步可用。
- 新增数据收集、权限、登录、SDK 或广告能力时，同步检查隐私文案和上架声明。

## Checklist

- Settings 是否能独立打开并完成所有系统动作。
- Support / Legal / Subscription 是否都从配置和 UseCase 进入。
- 订阅失败是否有受控状态。
- Terms / Privacy 是否在所有付费入口可访问。
