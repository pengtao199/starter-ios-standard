# Localization Rules

## Scope

适用于用户可见文案、Info.plist 权限文案、设置项、错误提示、空态和订阅页文案。

## Goal

用户可见文案必须可本地化，英文与简体中文同步维护。

## Source Of Truth

- `StarterApp/Resources/Localization/en.lproj/Localizable.strings`
- `StarterApp/Resources/Localization/zh-Hans.lproj/Localizable.strings`
- `StarterApp/Resources/Localization/en.lproj/InfoPlist.strings`
- `StarterApp/Resources/Localization/zh-Hans.lproj/InfoPlist.strings`

## Key Format

统一使用：

```text
feature.scope.name
```

## Rules

- 新增用户文案必须同次变更补齐英文与简体中文。
- SwiftUI 文案优先使用 `LocalizedStringKey`、`LocalizedStringResource` 或 `String(localized:)`。
- Info.plist 权限文案必须同步 `InfoPlist.strings`。
- Store、UseCase、Network 层不得生产最终用户文案，只返回状态或错误类型。
- `Tools/reset_project.rb` 会替换 App 名和订阅标题，相关 key 不能随意改名。
- 本地化 key 必须可静态搜索，禁止运行时拼接 key。

## Avoid

- 在 View 中硬编码中文或英文用户文案。
- 只补一种语言。
- 用服务端错误原文直接展示给用户。
- key 名承载临时 UI 布局细节。

## Checklist

- 新文案是否中英文同步。
- 权限文案是否进入 `InfoPlist.strings`。
- key 是否符合 `feature.scope.name`。
- 是否没有运行时拼 key。
