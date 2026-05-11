import Foundation

struct SubscriptionConfig: Equatable, Sendable {
    let title: String
    let featureItems: [SubscriptionFeatureSpec]
    let storefrontConfiguration: SubscriptionStorefrontConfiguration

    static let `default` = SubscriptionConfig(
        title: "Starter Pro",
        featureItems: [
            SubscriptionFeatureSpec(iconName: "sparkles", titleKey: "subscription.feature.premium"),
            SubscriptionFeatureSpec(iconName: "bolt.fill", titleKey: "subscription.feature.faster_workflows"),
            SubscriptionFeatureSpec(iconName: "crown.fill", titleKey: "subscription.feature.unlock_everything")
        ],
        storefrontConfiguration: SubscriptionStorefrontConfiguration(
            productIDs: [
                "co.example.starterapp.pro.yearly",
                "co.example.starterapp.pro.monthly"
            ],
            defaultProductID: "co.example.starterapp.pro.yearly"
        )
    )
}
