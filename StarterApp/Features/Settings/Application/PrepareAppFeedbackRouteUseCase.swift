@MainActor
struct PrepareAppFeedbackRouteUseCase {
    private let supportActionRepository: SupportActionRepositoryProtocol

    init(supportActionRepository: SupportActionRepositoryProtocol) {
        self.supportActionRepository = supportActionRepository
    }

    func execute() -> FeedbackRoute {
        supportActionRepository.makeFeedbackRoute(
            subject: String(localized: "settings.feedback.subject")
        )
    }
}
