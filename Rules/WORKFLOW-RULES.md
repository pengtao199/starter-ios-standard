# Workflow Rules

## Scope

适用于 Starter 任务开始、实现顺序、验证、提交和文档维护。

## Goal

让新项目和后续演进都按稳定顺序推进，避免一上来把系统页、配置和业务能力写乱。

## Start Of Task

- 先读根 `AGENTS.md`。
- 再读命中的 `Rules/*.md`。
- 每次任务先做 skill 匹配；命中 skill 时按 skill 执行。
- 先看当前工作区状态，保护 unrelated 改动。
- 默认不 commit；用户明确要求后才提交。
- 默认在 `main` 本地提交；除非用户明确要求，禁止新建分支。

## New App Order

- Day 0：运行 `ruby Tools/generate_project.rb`，确认工程可编译、可启动，系统入口可打开。
- Day 1：先改 `Config/`，包括 App、Support、Legal、Subscription。
- Day 2：先稳定 `Settings / Support / Legal / Subscription`。
- Day 3：创建第一个真实业务 Feature。
- Day 4：接网络与真实数据。
- Day 5+：按需补缓存、下载、媒体、广告、埋点、远程配置等可选能力。

## After Reset

- 运行 `ruby Tools/reset_project.rb` 初始化真实 App 后，必须删除或重写根 `README.md`。
- 新 App 的 `README.md` 只能保留真实项目说明、运行方式、配置说明和发布注意事项。
- 不要让 Starter 的初始化命令、基座定位和占位品牌文案原样留在真实 App 仓库里。
- 如果仍需记录 Starter 来源，放在简短的迁移记录或 `Plans/` 中，不作为根 README 主体。

## Fixed Feature Flow

- 先确认 Feature 名和职责边界。
- 先补配置和本地化 key。
- 先建 `Presentation/View + Store`。
- 再补 `Application/UseCase`。
- 再补 `Domain/Models`。
- 有真实数据访问时才补 `RepositoryProtocol + Repository`。
- 涉及权限、SDK、订阅或数据收集时同步补合规声明。

## Prohibited Order

- 一上来先删系统页面。
- 一上来先接重媒体能力。
- 一上来先把配置散落进页面。
- View 直接接接口。
- Store 直接拼 request。
- UseCase 直接操作 `URLSession`。

## Documentation Rules

- 根 `README.md` 只写 Starter 使用说明。
- 基于 Starter 初始化出的真实 App，根 `README.md` 必须改写为真实项目说明或删除。
- `AGENTS.md` 和 `Rules/` 只写开发规则。
- `Docs/` 放项目说明、PRD、参考材料和非规则类文档。
- `Plans/` 写阶段计划、执行方案和决策记录。
- 不新增 `Docs/` 作为第二套开发规则入口。

## Verification

- 改源码结构后运行 `ruby Tools/generate_project.rb`。
- 改 Swift 代码后尽量跑一次 Xcode 编译或说明无法运行原因。
- 改本地化后检查英文与简体中文 key 是否同步。
- 改合规相关能力后检查 `PrivacyInfo.xcprivacy`、Info.plist 权限文案和 App Store Connect 声明影响。
