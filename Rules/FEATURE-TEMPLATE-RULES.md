# Feature Template Rules

## 标准目录

```text
Features/<Feature>/
├── Presentation/
├── Application/
├── Domain/
└── Infrastructure/
```

## 起手模板

最小文件集：

1. `<Feature>View.swift`
2. `<Feature>Store.swift`
3. 一个明确动作的 `UseCase`
4. 一个业务模型文件

## 原则

1. 先最小主链路
2. 没有真实依赖不提前造空壳 Infrastructure
