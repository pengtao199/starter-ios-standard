import Foundation

@MainActor
struct PrepareAppShareUseCase {
    private let supportActionRepository: SupportActionRepositoryProtocol

    init(supportActionRepository: SupportActionRepositoryProtocol) {
        self.supportActionRepository = supportActionRepository
    }

    func execute() -> URL? {
        supportActionRepository.makeShareURL()
    }
}
