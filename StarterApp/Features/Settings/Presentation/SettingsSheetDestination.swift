import Foundation

enum SettingsSheetDestination: Identifiable, Equatable {
    case share(url: URL)
    case feedbackComposer(recipient: String, subject: String)
    case legalDocument(LegalDocumentType)

    var id: String {
        switch self {
        case let .share(url):
            "share-\(url.absoluteString)"
        case let .feedbackComposer(recipient, subject):
            "feedback-\(recipient)-\(subject)"
        case let .legalDocument(type):
            "legal-\(type)"
        }
    }
}

enum SettingsFullScreenDestination: String, Identifiable, Equatable, Sendable {
    case subscription

    var id: String {
        rawValue
    }
}
