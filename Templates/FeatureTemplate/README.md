# Feature Template

用于生成新的标准 Feature。

最小建议：

1. `Presentation/<Feature>View.swift`
2. `Presentation/<Feature>Store.swift`
3. `Application/Load<Feature>UseCase.swift`
4. `Domain/<Feature>Models.swift`

只有当出现真实数据访问时，再补：

1. `Domain/<Feature>RepositoryProtocol.swift`
2. `Infrastructure/<Feature>Repository.swift`
