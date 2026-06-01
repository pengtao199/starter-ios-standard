import Foundation

struct LegalConfig: Equatable, Sendable {
    let termsOfServiceURL: URL
    let privacyPolicyURL: URL

    static let `default` = LegalConfig(
        termsOfServiceURL: URL(string: "https://example.com/legal/terms")!,
        privacyPolicyURL: URL(string: "https://example.com/legal/privacy")!
    )
}
