# State Model Rules

## Scope

适用于页面加载态、刷新态、分页态、错误态和空态。

## Goal

用统一状态模型表达页面主内容和次级操作，避免每个页面各写一套加载分支。

## Primary State

- `skeleton`
- `loading`
- `content`
- `empty`
- `error`

## Secondary State

- `idle`
- `refreshing`
- `loadingMore`
- `refreshError`
- `loadMoreError`

## Rules

- 先确定主状态，再写视图分支。
- 已有内容优先保留；刷新失败不应替换整页内容。
- 次级状态不得抢占整页主内容。
- 主状态用于首次加载和无可展示内容的情况。
- 次级状态用于刷新、加载更多、局部失败和用户可继续操作的情况。
- 页面容器优先复用 `PageStateContainer`。
- 新状态文案必须走本地化 key。

## Avoid

- 在 View 内散落多个布尔值组合出隐式状态机。
- 刷新失败后把 `content` 直接变成整页 `error`。
- 空态和错误态共用同一份文案。

## Checklist

- 主状态和次级状态是否职责分离。
- 已有内容是否在次级错误时保留。
- retry 入口是否明确。
- 状态文案是否中英文同步。
