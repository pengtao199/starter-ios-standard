import Foundation
import StoreKit

actor StoreKitSubscriptionRepository: SubscriptionStoreKitRepositoryProtocol {
    private let productIDs: Set<String>

    init(storefrontConfiguration: SubscriptionStorefrontConfiguration) {
        self.productIDs = Set(storefrontConfiguration.productIDs)
    }

    func loadProducts() async throws -> [SubscriptionStoreProduct] {
        guard productIDs.isEmpty == false else {
            return []
        }

        let products = try await Product.products(for: Array(productIDs))
        return products.map { product in
            let subscriptionPeriod = product.subscription?.subscriptionPeriod
            let introductoryOfferPeriod = product.subscription?.introductoryOffer?.period
            return SubscriptionStoreProduct(
                productID: product.id,
                displayName: product.displayName,
                displayPrice: product.displayPrice,
                price: product.price,
                currencyCode: product.priceFormatStyle.currencyCode,
                periodUnit: resolvePeriodUnit(subscriptionPeriod),
                periodValue: subscriptionPeriod?.value ?? 0,
                hasFreeTrial: product.subscription?.introductoryOffer?.paymentMode == .freeTrial,
                introductoryTrialUnit: resolveOptionalPeriodUnit(introductoryOfferPeriod),
                introductoryTrialValue: introductoryOfferPeriod?.value
            )
        }
    }

    func purchase(productID: String, now: Date) async throws -> SubscriptionPurchaseResult {
        guard let product = try await Product.products(for: [productID]).first else {
            throw PurchaseError.productNotFound
        }

        let result = try await product.purchase()
        switch result {
        case let .success(verification):
            guard case let .verified(transaction) = verification else {
                throw PurchaseError.verificationFailed
            }

            let entitlement = Self.entitlement(from: transaction, now: now)
            await transaction.finish()
            return .success(entitlement: entitlement)
        case .pending:
            return .pending
        case .userCancelled:
            return .cancelled
        @unknown default:
            throw PurchaseError.unknown
        }
    }

    func loadCurrentEntitlement(now: Date) async -> SubscriptionEntitlement? {
        var resolvedEntitlement: SubscriptionEntitlement?

        for await result in Transaction.currentEntitlements {
            guard case let .verified(transaction) = result,
                  productIDs.contains(transaction.productID),
                  let entitlement = Self.entitlement(from: transaction, now: now)
            else {
                continue
            }

            if let currentEntitlement = resolvedEntitlement {
                resolvedEntitlement = Self.preferredEntitlement(
                    lhs: currentEntitlement,
                    rhs: entitlement
                )
            } else {
                resolvedEntitlement = entitlement
            }
        }

        return resolvedEntitlement
    }

    func restorePurchases() async throws {
        try await AppStore.sync()
    }
}

private extension StoreKitSubscriptionRepository {
    enum PurchaseError: Error {
        case productNotFound
        case verificationFailed
        case unknown
    }

    func resolvePeriodUnit(
        _ period: Product.SubscriptionPeriod?
    ) -> SubscriptionStoreProductPeriodUnit {
        guard let period else {
            return .unknown
        }

        switch period.unit {
        case .day:
            return .day
        case .week:
            return .week
        case .month:
            return .month
        case .year:
            return .year
        @unknown default:
            return .unknown
        }
    }

    func resolveOptionalPeriodUnit(
        _ period: Product.SubscriptionPeriod?
    ) -> SubscriptionStoreProductPeriodUnit? {
        guard period != nil else {
            return nil
        }

        return resolvePeriodUnit(period)
    }

    static func entitlement(
        from transaction: Transaction,
        now: Date
    ) -> SubscriptionEntitlement? {
        if let revocationDate = transaction.revocationDate, revocationDate <= now {
            return nil
        }

        if let expirationDate = transaction.expirationDate, expirationDate <= now {
            return nil
        }

        return SubscriptionEntitlement(
            productID: transaction.productID,
            plan: SubscriptionPlan(productID: transaction.productID),
            status: .active,
            isSubscribed: true,
            expiresAt: transaction.expirationDate,
            autoRenews: transaction.expirationDate != nil,
            purchaseDate: transaction.purchaseDate,
            lastRefreshedAt: now
        )
    }

    static func preferredEntitlement(
        lhs: SubscriptionEntitlement,
        rhs: SubscriptionEntitlement
    ) -> SubscriptionEntitlement {
        let lhsExpiration = lhs.expiresAt ?? .distantFuture
        let rhsExpiration = rhs.expiresAt ?? .distantFuture

        if rhsExpiration != lhsExpiration {
            return rhsExpiration > lhsExpiration ? rhs : lhs
        }

        let lhsPurchaseDate = lhs.purchaseDate ?? .distantPast
        let rhsPurchaseDate = rhs.purchaseDate ?? .distantPast
        return rhsPurchaseDate > lhsPurchaseDate ? rhs : lhs
    }
}
