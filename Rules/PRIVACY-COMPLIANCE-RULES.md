# Privacy Compliance Rules

## Scope

适用于隐私清单、权限声明、数据收集、订阅、第三方 SDK、广告、登录和 App Store 上架检查。

## Goal

Starter 默认保持最小可审核合规面：不默认追踪、不默认广告、不声明无真实用途的权限。

## Current Baseline

- `StarterApp/PrivacyInfo.xcprivacy`
- Settings 内可访问 Privacy Policy
- Subscription 内可访问 Terms / Privacy
- StoreKit 2 购买与恢复购买链路
- `UserDefaults` 仅用于 app 内偏好和本地订阅状态缓存

## Privacy Manifest Rules

- 使用 required reason API 时，必须同步更新 `PrivacyInfo.xcprivacy`。
- 当前已声明 `NSPrivacyAccessedAPICategoryUserDefaults`。
- 默认 `NSPrivacyTracking` 必须保持 `false`。
- 默认 `NSPrivacyCollectedDataTypes` 必须保持空数组，直到真实收集用户数据。
- 引入第三方 SDK 时，必须确认 SDK 是否自带有效 privacy manifest。
- App Store Connect Privacy Nutrition Labels 必须与 manifest、网络行为和 SDK 行为一致。

## Permission Rules

- 没有真实功能需求时，不新增相机、相册、定位、麦克风、通讯录、日历、蓝牙等 usage description。
- 每个 usage description 必须说明具体功能用途，禁止泛泛写“需要权限”。
- 权限文案必须进入英文和简体中文 `InfoPlist.strings`。
- 权限请求时机必须贴近用户动作，禁止启动即弹。

## ATT And Ads

- 默认不启用 ATT，不引入广告 SDK，不声明 tracking domains。
- 加入广告或跨 app / web tracking 前，先判断是否构成 tracking。
- tracking domains 只能在用户授权后连接。
- ATT 文案和 Privacy Nutrition Labels 必须同步更新。

## Subscription Compliance

- 订阅页必须提供恢复购买入口。
- 订阅页必须提供 Terms / Privacy 入口。
- 真实商品上线前，必须验证价格、周期、试用、自动续订说明是否足够清晰。
- 数字内容和高级功能默认走 StoreKit，不引导用户外部支付。

## SDK Intake Checklist

- SDK 名称和版本。
- 业务用途。
- 是否收集数据。
- 是否用于 tracking。
- 是否自带 `PrivacyInfo.xcprivacy`。
- 是否需要额外 Info.plist 权限。

## Release Checklist

- Release 构建无编译错误。
- `PrivacyInfo.xcprivacy` 在 app bundle 内。
- Privacy Policy URL 可访问，且 app 内也能打开。
- Terms URL 可访问。
- Settings / Subscription 的法务入口可打开。
- 订阅恢复购买可触发。
- App 内没有 Starter 占位品牌文案。
- App Store Connect 隐私标签与真实行为一致。
