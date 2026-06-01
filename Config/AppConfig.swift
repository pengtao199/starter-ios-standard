import Foundation

struct AppConfig: Equatable, Sendable {
    let displayName: String
    let bundleIdentifier: String
    let version: String
    let buildNumber: String
    let networkBaseURL: URL

    static let `default` = AppConfig(
        displayName: "Starter App",
        bundleIdentifier: "co.example.starterapp",
        version: "1.0",
        buildNumber: "1",
        networkBaseURL: URL(string: "https://api.example.com")!
    )
}
