# Development Order

## 目标

这份文档回答一个实际问题：

拿到 `starter-ios-standard` 后，应该按什么顺序开始开发一个新 app，才能最快稳定落地，而不是一上来就把结构写乱。

## Day 0：先做基座确认

第一天不要先改业务页面，先确认以下内容：

1. 运行 `ruby Tools/generate_project.rb`
2. 打开 `StarterApp.xcodeproj`
3. 确认工程能编译、能启动
4. 确认 `Home / Settings` 两个 root tab 正常
5. 确认外观、语言、订阅页入口、法务页入口都能打开

如果这一步没过，不要继续加业务功能。

## Day 1：先改配置，再改业务

第一个真正的开发动作必须是改 `Config/`，而不是改页面：

1. 改 `AppConfig`
   - App 名
   - Bundle ID
   - API Base URL
2. 改 `SupportConfig`
   - App Store ID
   - Share URL
   - Support Email
3. 改 `LegalConfig`
   - Terms URL
   - Privacy URL
4. 改 `SubscriptionConfig`
   - 产品 ID
   - 默认方案
   - 付费页 feature 列表

原则：

1. 先让所有 app 级差异项从配置层进入
2. 不要一边开发一边把配置散落到页面和 Store 里

## Day 2：先稳定系统页面

第二步优先处理 Starter 自带的公共页面，而不是业务首页：

1. `Settings`
2. `LegalDocument`
3. `Subscription`
4. `Overlay / Page State` 展示口径

建议顺序：

1. 先改 Settings 文案与信息结构
2. 再改 Legal 文档入口
3. 再改 Subscription 的文案和 plan 展示
4. 最后决定是否要删掉 Starter 里的 demo 内容

原因：

1. 几乎每个新 app 都会先需要这些页面
2. 这些页面稳定后，后续业务 Feature 能更顺地挂上去

## Day 3：创建第一个真实 Feature

只有在配置和系统页面都稳定后，才开始创建第一个业务 Feature。

建议顺序：

1. 先确定 Feature 名
2. 先建 `Presentation/View + Store`
3. 再补 `Application/UseCase`
4. 再补 `Domain/Models`
5. 有真实数据访问时才补 `RepositoryProtocol + Repository`

不要一开始就建很多子目录和空文件。

## Day 4：接网络与真实数据

Starter 的网络基座是最小版，所以接业务接口时要按固定顺序来：

1. 先写 Feature 私有 `API`
2. 再写 `RepositoryProtocol`
3. 再写 `Repository`
4. 再让 `UseCase` 调用仓储
5. 最后让 `Store` 消费 `UseCase`

禁止顺序：

1. View 直接接接口
2. Store 直接拼 request
3. UseCase 直接操作 URLSession

## Day 5+：按需补可选能力

以下能力都不是新项目第一周默认必须项：

1. 缓存
2. 下载
3. 图片库保存
4. 媒体处理
5. 广告
6. 埋点
7. 远程配置

判断原则：

1. 只有出现真实需求，才把它们补进 Starter 的当前项目
2. 没有需求时，不要为了“以后可能用到”提前引入

## 不同项目类型的起手差异

### 工具类 App

优先顺序：

1. Config
2. Settings / Support
3. 第一个业务 Feature
4. Subscription

说明：

工具类 app 很多时候不需要一开始就把网络做重。

### 订阅类 App

优先顺序：

1. Config
2. Subscription
3. Settings / Legal / Support
4. 第一个业务 Feature
5. Network

说明：

如果商业化是核心，先把 paywall 和恢复购买链路稳定下来。

### 内容类 App

优先顺序：

1. Config
2. Settings / Subscription
3. 第一个内容 Feature
4. Network
5. 缓存 / 下载 / 媒体能力

说明：

不要一上来就把 Pro 级媒体链路全部带进来，先验证内容主路径。

## 每次新功能的固定执行顺序

以后每次在 Starter 上继续开发，建议统一按下面的顺序做：

1. 先看 `Rules/AGENTS.md`
2. 再看命中的专项规则
3. 先补配置和本地化 key
4. 再写 Feature 主链路
5. 最后做静态检查和编译验证

## 一个稳定的默认节奏

如果你不想每次重新判断，默认就按这个节奏：

1. 第一天：改配置 + 跑工程
2. 第二天：收口 Settings / Subscription / Legal
3. 第三天：做第一个业务 Feature
4. 第四天：接真实接口
5. 第五天：补可选能力

这是当前 `starter-ios-standard` 最推荐的上手顺序。
