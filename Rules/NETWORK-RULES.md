# Network Rules

## Scope

适用于真实接口接入、Repository 实现、HTTP Client 扩展和错误处理。

## Goal

保持网络能力是可替换的基础设施，不让请求构造和传输细节泄漏到 UI 或业务动作里。

## Standard Chain

- `View`
- `Store`
- `UseCase`
- `RepositoryProtocol`
- `Repository`
- `HTTPClientProtocol`
- `URLSessionHTTPClient`

## Baseline

- `HTTPMethod`
- `RequestDescriptor`
- `HTTPClientProtocol`
- `URLRequestBuilder`
- `URLSessionHTTPClient`
- `NetworkError`

## Rules

- `Presentation` 不直接请求网络。
- `Store` 不拼 request、不解码 response。
- `UseCase` 依赖 Feature 或 Core 的 Repository 协议。
- `Repository` 负责把领域动作转换成 request / response。
- `HTTPClientProtocol` 只表达通用请求能力，不承载业务 API。
- API Base URL 来自 `AppConfig`。
- 错误先归一到 `NetworkError` 或 Feature 明确错误模型，再交给 Store 显示。

## Avoid

- `UseCase` 直接创建 `URLRequest`。
- 为每个接口复制一套 HTTP Client。
- View 根据 HTTP status code 写 UI 分支。
- 在网络层写用户可见文案。

## Checklist

- 请求链路是否从 Store 进入 UseCase。
- Repository 协议是否位于正确领域边界。
- 网络错误是否被映射为页面可消费状态。
- Base URL、header 策略和认证策略是否没有写死在 View / Store。
