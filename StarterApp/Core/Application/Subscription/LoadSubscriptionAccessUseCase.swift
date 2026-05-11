import Foundation

struct LoadSubscriptionAccessUseCase: Sendable {
    private let subscriptionStateRepository: SubscriptionStateRepositoryProtocol
    let storefrontConfiguration: SubscriptionStorefrontConfiguration

    init(
        subscriptionStateRepository: SubscriptionStateRepositoryProtocol,
        storefrontConfiguration: SubscriptionStorefrontConfiguration
    ) {
        self.subscriptionStateRepository = subscriptionStateRepository
        self.storefrontConfiguration = storefrontConfiguration
    }

    @MainActor
    func execute(now: Date = Date()) -> SubscriptionAccess {
        let entitlement = subscriptionStateRepository.loadEntitlement()
            ?? SubscriptionEntitlement.none(lastRefreshedAt: now)
        return SubscriptionAccess(entitlement: entitlement, now: now)
    }
}
