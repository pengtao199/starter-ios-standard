# View Component Rules

## Scope

适用于 SwiftUI `View`、页面私有组件、`Common/UI` 组件和 Preview。

## Goal

让 View 保持声明式、原生、可预览，只表达 UI 和用户意图。

## Rules

- View 读取 Store 状态，通过 Store 方法发送用户意图。
- View 不直接调用 UseCase、Repository、SDK 或网络。
- 页面私有组件优先放在同文件 `private extension` 或 Feature 私有文件中。
- 只有跨 Feature 稳定复用、无业务语义的组件才进入 `Common/UI`。
- 布局间距、圆角、页面 padding 优先使用 `LayoutToken` 或已有本地 token。
- 用户可见文案必须使用本地化 key。
- 导航、sheet、full screen cover 的状态归 Store 或明确的页面状态管理。
- 新增复杂页面时保留 SwiftUI Preview，Preview 依赖使用 noop 或本地 mock。

## Avoid

- View 内创建外部依赖。
- View 内写业务分支、接口解析或持久化逻辑。
- 为单页视觉效果提前抽通用组件。
- 把 demo 文案、产品名、URL 直接写进 View。

## Checklist

- View 是否只依赖状态和意图。
- 组件是否放在最小合理作用域。
- 文案是否已本地化。
- Preview 是否能表达主要状态。
