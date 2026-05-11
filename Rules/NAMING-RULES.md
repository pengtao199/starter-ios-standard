# Naming Rules

## 目录命名

1. 顶层只允许：`App / Features / Core / Common / Config / Resources`
2. Feature 名使用 `PascalCase`
3. Feature 分层固定：`Presentation / Application / Domain / Infrastructure`

## 文件后缀

1. 页面：`<Name>View.swift`
2. 状态源：`<Name>Store.swift`
3. 动作：`<Action>NameUseCase.swift`
4. 仓储协议：`<Name>RepositoryProtocol.swift`
5. 仓储实现：`<Name>Repository.swift`

## 原则

1. 一个概念只保留一个 canonical name
2. 禁止 `Helper / Utils / Manager` 滥用
