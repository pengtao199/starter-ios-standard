import Foundation

struct RestoreSubscriptionPurchasesUseCase: Sendable {
    private let subscriptionStoreKitRepository: SubscriptionStoreKitRepositoryProtocol
    private let refreshSubscriptionStatusUseCase: RefreshSubscriptionStatusUseCase

    init(
        subscriptionStoreKitRepository: SubscriptionStoreKitRepositoryProtocol,
        refreshSubscriptionStatusUseCase: RefreshSubscriptionStatusUseCase
    ) {
        self.subscriptionStoreKitRepository = subscriptionStoreKitRepository
        self.refreshSubscriptionStatusUseCase = refreshSubscriptionStatusUseCase
    }

    func execute(now: Date = Date()) async throws -> SubscriptionEntitlement {
        try await subscriptionStoreKitRepository.restorePurchases()
        return await refreshSubscriptionStatusUseCase.execute(now: now)
    }
}
