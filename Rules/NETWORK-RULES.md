# Network Rules

## 标准链路

1. `View`
2. `Store`
3. `UseCase`
4. `RepositoryProtocol`
5. `Repository`
6. `HTTPClientProtocol`
7. `URLSessionHTTPClient`

## 最小基座

1. `HTTPMethod`
2. `RequestDescriptor`
3. `HTTPClientProtocol`
4. `URLRequestBuilder`
5. `URLSessionHTTPClient`
6. `NetworkError`

## 禁止

1. `Presentation` 直接请求网络
2. `UseCase` 直接拼 request descriptor
