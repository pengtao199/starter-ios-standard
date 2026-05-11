# State Model Rules

## 主状态

1. `skeleton`
2. `loading`
3. `content`
4. `empty`
5. `error`

## 次级状态

1. `idle`
2. `refreshing`
3. `loadingMore`
4. `refreshError`
5. `loadMoreError`

## 原则

1. 先统一状态，再写视图
2. 已有内容优先保留
3. 次级状态不得抢占整页主内容
