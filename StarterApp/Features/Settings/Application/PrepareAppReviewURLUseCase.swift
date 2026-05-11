import Foundation

@MainActor
struct PrepareAppReviewURLUseCase {
    private let supportActionRepository: SupportActionRepositoryProtocol

    init(supportActionRepository: SupportActionRepositoryProtocol) {
        self.supportActionRepository = supportActionRepository
    }

    func execute() -> URL? {
        supportActionRepository.makeReviewURL()
    }
}
