import Foundation

enum LegalDocumentType: Hashable, Sendable {
    case terms
    case privacy
}

struct LegalDocumentContent: Equatable, Sendable {
    let type: LegalDocumentType
    let url: URL
}
