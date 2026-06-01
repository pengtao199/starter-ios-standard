import Foundation

struct RefreshSubscriptionStatusUseCase: Sendable {
    private let subscriptionStoreKitRepository: SubscriptionStoreKitRepositoryProtocol
    private let subscriptionStateRepository: SubscriptionStateRepositoryProtocol

    init(
        subscriptionStoreKitRepository: SubscriptionStoreKitRepositoryProtocol,
        subscriptionStateRepository: SubscriptionStateRepositoryProtocol
    ) {
        self.subscriptionStoreKitRepository = subscriptionStoreKitRepository
        self.subscriptionStateRepository = subscriptionStateRepository
    }

    func execute(now: Date = Date()) async -> SubscriptionEntitlement {
        let activeEntitlement = await subscriptionStoreKitRepository.loadCurrentEntitlement(now: now)
        return await persistEntitlement(activeEntitlement, now: now)
    }

    func execute(
        activeEntitlement: SubscriptionEntitlement?,
        now: Date = Date()
    ) async -> SubscriptionEntitlement {
        await persistEntitlement(activeEntitlement, now: now)
    }
}

private extension RefreshSubscriptionStatusUseCase {
    func persistEntitlement(
        _ activeEntitlement: SubscriptionEntitlement?,
        now: Date
    ) async -> SubscriptionEntitlement {
        if let activeEntitlement {
            await subscriptionStateRepository.saveEntitlement(activeEntitlement)
            return activeEntitlement
        }

        if let cachedEntitlement = await subscriptionStateRepository.loadEntitlement(),
           cachedEntitlement.productID != nil {
            let expiredEntitlement = cachedEntitlement.expired(lastRefreshedAt: now)
            await subscriptionStateRepository.saveEntitlement(expiredEntitlement)
            return expiredEntitlement
        }

        let noEntitlement = SubscriptionEntitlement.none(lastRefreshedAt: now)
        await subscriptionStateRepository.saveEntitlement(noEntitlement)
        return noEntitlement
    }
}
