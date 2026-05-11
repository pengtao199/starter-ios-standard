# Localization Rules

## 真源

1. `StarterApp/Resources/Localization/en.lproj/Localizable.strings`
2. `StarterApp/Resources/Localization/zh-Hans.lproj/Localizable.strings`
3. `StarterApp/Resources/Localization/en.lproj/InfoPlist.strings`
4. `StarterApp/Resources/Localization/zh-Hans.lproj/InfoPlist.strings`

## 命名

统一使用：

`feature.scope.name`

## 规则

1. 新增用户文案必须同提交补齐双语
2. 默认优先使用 `LocalizedStringResource` / `String(localized:)`
3. 禁止硬编码用户可见文案
4. 禁止运行时拼 key
