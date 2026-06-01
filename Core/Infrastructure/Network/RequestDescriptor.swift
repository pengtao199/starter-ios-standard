import Foundation

enum AuthenticationPolicy: Sendable {
    case none
}

enum RequestBody: Sendable {
    case none
    case json(Data)
    case data(Data, contentType: String?)
}

struct RequestDescriptor: HTTPRequestConvertible, Sendable {
    let path: String
    var method: HTTPMethod
    var queryItems: [URLQueryItem]
    var headers: [String: String]
    var body: RequestBody
    var authenticationPolicy: AuthenticationPolicy
    var acceptableStatusCodes: Set<Int>
    var timeoutInterval: TimeInterval?

    init(
        path: String,
        method: HTTPMethod = .get,
        queryItems: [URLQueryItem] = [],
        headers: [String: String] = [:],
        body: RequestBody = .none,
        authenticationPolicy: AuthenticationPolicy = .none,
        acceptableStatusCodes: Set<Int> = Set(200 ..< 300),
        timeoutInterval: TimeInterval? = nil
    ) {
        self.path = path
        self.method = method
        self.queryItems = queryItems
        self.headers = headers
        self.body = body
        self.authenticationPolicy = authenticationPolicy
        self.acceptableStatusCodes = acceptableStatusCodes
        self.timeoutInterval = timeoutInterval
    }
}
