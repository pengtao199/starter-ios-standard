# Starter iOS AGENTS

## Scope

`starter-ios-standard` 根级执行规则。`Rules/` 只放专项规则，不放第二个 `AGENTS.md`。

根目录 `README.md` 是 Starter 使用说明；`Rules/` 是项目开发规则；`Docs/` 放项目说明、PRD 和参考材料；`Plans/` 只记录阶段计划和决策过程。

## Rules

- 先读本文件，再读命中的 `Rules/*.md`。
- 每次任务先做 skill 匹配；命中 skill 时按 skill 执行。
- 开发、优化、性能任务先给出：现象 -> 链路 -> 根因 -> 验证点。
- 用户可见文案必须本地化，英文与简体中文同步。
- iOS UI 原生优先，禁止炫技型自定义。
- 新代码必须放到职责正确目录。
- 默认不 commit；用户明确要求后才提交。
- 默认在 `main` 本地提交；除非用户明确要求，禁止新建分支。
- 不确定或争议强的 iOS 能力先查 Apple 官方文档。
- 不回滚、覆盖、清理与当前任务无关的工作区改动。
- Starter 默认先服务 Standard 主模板，Lite / Pro 差异只在需求明确后演进。
- App 级差异项先进入 `Config/`，禁止散落到页面、Store 或 Repository。
- 系统页先稳定，再创建真实业务 Feature。
- `Docs/` 不作为开发规则入口；稳定使用说明进入 `README.md`，开发约束进入 `Rules/`，阶段过程进入 `Plans/`。

## Rule Map

- 分层契约：`Rules/LAYERING-CONTRACT-RULES.md`
- App 入口：`Rules/APP-BOOTSTRAP-RULES.md`
- 配置收口：`Rules/CONFIG-RULES.md`
- Feature 结构：`Rules/FEATURE-STRUCTURE-RULES.md`
- View/组件：`Rules/VIEW-COMPONENT-RULES.md`
- 原生 UI：`Rules/UI-NATIVE-RULES.md`
- 状态模型：`Rules/STATE-MODEL-RULES.md`
- 本地化：`Rules/LOCALIZATION-RULES.md`
- 设置/订阅：`Rules/SETTINGS-SUBSCRIPTION-RULES.md`
- 隐私合规：`Rules/PRIVACY-COMPLIANCE-RULES.md`
- 网络：`Rules/NETWORK-RULES.md`
- 性能/重构：`Rules/PERFORMANCE-REFACTOR-RULES.md`
- 命名：`Rules/NAMING-RULES.md`
- 工作流：`Rules/WORKFLOW-RULES.md`

## Checklist

- 已读取本文件与命中的专项规则。
- 已确认 `@main` 在 `StarterApp/App/StarterApp.swift`。
- 已保护 unrelated 工作区改动。
- 已优先检查配置、本地化和合规影响。
- 已按 `Config -> Settings / Support / Legal / Subscription -> Feature -> Network -> Compliance -> Optional` 的稳定顺序推进。
