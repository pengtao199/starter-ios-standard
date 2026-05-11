import Foundation

struct SubscriptionFeatureSpec: Equatable, Sendable {
    let iconName: String
    let titleKey: String
}

struct SubscriptionFeatureItem: Identifiable, Equatable, Sendable {
    let iconName: String
    let titleKey: String

    var id: String {
        titleKey
    }
}

struct SubscriptionViewContent: Equatable, Sendable {
    let title: String
    let subtitleKey: String
    let activeBadgeKey: String?
    let isSubscriptionActive: Bool
    let featureItems: [SubscriptionFeatureItem]
    let productIDs: [String]
    let defaultProductID: String?
}

enum SubscriptionPlanUnit: String, Equatable, Sendable {
    case day
    case week
    case month
    case year
    case unknown
}

struct SubscriptionPlanItem: Identifiable, Equatable, Sendable {
    let productID: String
    let plan: SubscriptionPlan
    let displayName: String
    let titleKey: String?
    let displayPrice: String
    let equivalentWeeklyPrice: String?
    let savePercent: Int?
    let unit: SubscriptionPlanUnit
    let hasFreeTrial: Bool
    let introductoryTrialUnit: SubscriptionPlanUnit?
    let introductoryTrialValue: Int?

    var id: String {
        productID
    }
}
