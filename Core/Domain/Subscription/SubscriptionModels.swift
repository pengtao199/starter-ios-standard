import Foundation

enum SubscriptionPlan: String, Codable, CaseIterable, Equatable, Sendable {
    case weekly
    case monthly
    case yearly
    case unknown

    init(productID: String?) {
        guard let productID else {
            self = .unknown
            return
        }

        if productID.localizedCaseInsensitiveContains("year") {
            self = .yearly
        } else if productID.localizedCaseInsensitiveContains("month") {
            self = .monthly
        } else if productID.localizedCaseInsensitiveContains("week") {
            self = .weekly
        } else {
            self = .unknown
        }
    }
}

enum SubscriptionStatus: String, Codable, Equatable, Sendable {
    case none
    case active
    case expired
}

struct SubscriptionEntitlement: Codable, Equatable, Sendable {
    let productID: String?
    let plan: SubscriptionPlan
    let status: SubscriptionStatus
    let isSubscribed: Bool
    let expiresAt: Date?
    let autoRenews: Bool
    let purchaseDate: Date?
    let lastRefreshedAt: Date

    static func none(lastRefreshedAt: Date) -> SubscriptionEntitlement {
        SubscriptionEntitlement(
            productID: nil,
            plan: .unknown,
            status: .none,
            isSubscribed: false,
            expiresAt: nil,
            autoRenews: false,
            purchaseDate: nil,
            lastRefreshedAt: lastRefreshedAt
        )
    }

    func expired(lastRefreshedAt: Date) -> SubscriptionEntitlement {
        SubscriptionEntitlement(
            productID: productID,
            plan: plan,
            status: .expired,
            isSubscribed: false,
            expiresAt: expiresAt,
            autoRenews: false,
            purchaseDate: purchaseDate,
            lastRefreshedAt: lastRefreshedAt
        )
    }
}

struct SubscriptionAccess: Equatable, Sendable {
    let entitlement: SubscriptionEntitlement
    let isSubscriptionActive: Bool
    let shouldShowPaywallAccent: Bool

    init(entitlement: SubscriptionEntitlement, now _: Date) {
        let isActive = entitlement.isSubscribed && entitlement.status == .active
        self.entitlement = entitlement
        self.isSubscriptionActive = isActive
        self.shouldShowPaywallAccent = !isActive
    }
}

struct SubscriptionStorefrontConfiguration: Equatable, Sendable {
    let productIDs: [String]
    let defaultProductID: String?
}

enum SubscriptionStoreProductPeriodUnit: String, Equatable, Sendable {
    case day
    case week
    case month
    case year
    case unknown
}

struct SubscriptionStoreProduct: Equatable, Sendable {
    let productID: String
    let displayName: String
    let displayPrice: String
    let price: Decimal
    let currencyCode: String?
    let periodUnit: SubscriptionStoreProductPeriodUnit
    let periodValue: Int
    let hasFreeTrial: Bool
    let introductoryTrialUnit: SubscriptionStoreProductPeriodUnit?
    let introductoryTrialValue: Int?
}

enum SubscriptionPurchaseResult: Equatable, Sendable {
    case success(entitlement: SubscriptionEntitlement?)
    case pending
    case cancelled
}

protocol SubscriptionStoreKitRepositoryProtocol: Actor, Sendable {
    func loadProducts() async throws -> [SubscriptionStoreProduct]
    func purchase(productID: String, now: Date) async throws -> SubscriptionPurchaseResult
    func loadCurrentEntitlement(now: Date) async -> SubscriptionEntitlement?
    func restorePurchases() async throws
}

@MainActor
protocol SubscriptionStateRepositoryProtocol: Sendable {
    func loadEntitlement() -> SubscriptionEntitlement?
    func saveEntitlement(_ entitlement: SubscriptionEntitlement)
    func clearEntitlement()
}
