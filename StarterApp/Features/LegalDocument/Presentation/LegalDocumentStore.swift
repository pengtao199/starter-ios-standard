import Observation
import Foundation

@MainActor
@Observable
final class LegalDocumentStore {
    private(set) var content: LegalDocumentContent

    init(
        type: LegalDocumentType,
        resolveLegalDocumentUseCase: ResolveLegalDocumentUseCase
    ) {
        self.content = resolveLegalDocumentUseCase.execute(type: type)
    }

    var url: URL {
        content.url
    }
}
