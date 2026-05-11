import Foundation

struct PurchaseSubscriptionPlanUseCase: Sendable {
    private let subscriptionStoreKitRepository: SubscriptionStoreKitRepositoryProtocol
    private let refreshSubscriptionStatusUseCase: RefreshSubscriptionStatusUseCase

    init(
        subscriptionStoreKitRepository: SubscriptionStoreKitRepositoryProtocol,
        refreshSubscriptionStatusUseCase: RefreshSubscriptionStatusUseCase
    ) {
        self.subscriptionStoreKitRepository = subscriptionStoreKitRepository
        self.refreshSubscriptionStatusUseCase = refreshSubscriptionStatusUseCase
    }

    func execute(
        productID: String,
        now: Date = Date()
    ) async throws -> SubscriptionPurchaseResult {
        let purchaseResult = try await subscriptionStoreKitRepository.purchase(
            productID: productID,
            now: now
        )

        switch purchaseResult {
        case let .success(entitlement):
            if let entitlement {
                _ = await refreshSubscriptionStatusUseCase.execute(
                    activeEntitlement: entitlement,
                    now: now
                )
            } else {
                _ = await refreshSubscriptionStatusUseCase.execute(now: now)
            }
        case .pending, .cancelled:
            break
        }

        return purchaseResult
    }
}
