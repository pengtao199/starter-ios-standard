import Foundation

struct SupportConfig: Equatable, Sendable {
    let appStoreID: String
    let shareURL: URL
    let supportEmail: String

    static let `default` = SupportConfig(
        appStoreID: "0000000000",
        shareURL: URL(string: "https://example.com/app")!,
        supportEmail: "support@example.com"
    )
}
