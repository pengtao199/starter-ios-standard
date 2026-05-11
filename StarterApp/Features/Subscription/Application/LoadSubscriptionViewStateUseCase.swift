import Foundation

struct LoadSubscriptionViewStateUseCase {
    private let loadSubscriptionAccessUseCase: LoadSubscriptionAccessUseCase
    private let subscriptionConfig: SubscriptionConfig

    init(
        loadSubscriptionAccessUseCase: LoadSubscriptionAccessUseCase,
        subscriptionConfig: SubscriptionConfig
    ) {
        self.loadSubscriptionAccessUseCase = loadSubscriptionAccessUseCase
        self.subscriptionConfig = subscriptionConfig
    }

    @MainActor
    func execute(now: Date = Date()) -> SubscriptionViewContent {
        let access = loadSubscriptionAccessUseCase.execute(now: now)
        return SubscriptionViewContent(
            title: subscriptionConfig.title,
            subtitleKey: access.isSubscriptionActive
                ? "subscription.subtitle.active"
                : "subscription.subtitle.default",
            activeBadgeKey: access.isSubscriptionActive ? "subscription.badge.active" : nil,
            isSubscriptionActive: access.isSubscriptionActive,
            featureItems: subscriptionConfig.featureItems.map {
                SubscriptionFeatureItem(iconName: $0.iconName, titleKey: $0.titleKey)
            },
            productIDs: loadSubscriptionAccessUseCase.storefrontConfiguration.productIDs,
            defaultProductID: loadSubscriptionAccessUseCase.storefrontConfiguration.defaultProductID
        )
    }
}
