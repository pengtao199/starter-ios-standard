import Foundation

struct ResolveLegalDocumentUseCase {
    private let legalConfig: LegalConfig

    init(legalConfig: LegalConfig) {
        self.legalConfig = legalConfig
    }

    func execute(type: LegalDocumentType) -> LegalDocumentContent {
        let url: URL
        switch type {
        case .terms:
            url = legalConfig.termsOfServiceURL
        case .privacy:
            url = legalConfig.privacyPolicyURL
        }

        return LegalDocumentContent(type: type, url: url)
    }
}
