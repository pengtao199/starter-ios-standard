import Foundation

struct LoadSubscriptionPlanItemsUseCase {
    private let subscriptionStoreKitRepository: SubscriptionStoreKitRepositoryProtocol
    private let storefrontConfiguration: SubscriptionStorefrontConfiguration

    init(
        subscriptionStoreKitRepository: SubscriptionStoreKitRepositoryProtocol,
        storefrontConfiguration: SubscriptionStorefrontConfiguration
    ) {
        self.subscriptionStoreKitRepository = subscriptionStoreKitRepository
        self.storefrontConfiguration = storefrontConfiguration
    }

    func execute(locale: Locale) async throws -> [SubscriptionPlanItem] {
        let products = try await subscriptionStoreKitRepository.loadProducts()
        var remainingByID = Dictionary(uniqueKeysWithValues: products.map { ($0.productID, $0) })

        let preferredOrderProducts = storefrontConfiguration.productIDs.compactMap {
            remainingByID.removeValue(forKey: $0)
        }
        let orderedProducts = preferredOrderProducts + remainingByID.values.sorted {
            $0.displayName < $1.displayName
        }

        let weeklyPrices = orderedProducts.compactMap(weeklyEquivalentPrice)
        let baselineWeeklyPrice = weeklyPrices.max()

        return orderedProducts.map { product in
            let plan = SubscriptionPlan(productID: product.productID)
            let unit = resolvePlanUnit(for: product.periodUnit)
            let weeklyPrice = weeklyEquivalentPrice(for: product)
            return SubscriptionPlanItem(
                productID: product.productID,
                plan: plan,
                displayName: product.displayName,
                titleKey: resolveTitleKey(for: plan),
                displayPrice: formatCurrency(product.price, currencyCode: product.currencyCode, locale: locale),
                equivalentWeeklyPrice: weeklyPrice.map {
                    formatCurrency($0, currencyCode: product.currencyCode, locale: locale)
                },
                savePercent: resolveSavePercent(
                    candidateWeeklyPrice: weeklyPrice,
                    baselineWeeklyPrice: baselineWeeklyPrice
                ),
                unit: unit,
                hasFreeTrial: product.hasFreeTrial,
                introductoryTrialUnit: product.introductoryTrialUnit.map(resolvePlanUnit(for:)),
                introductoryTrialValue: product.introductoryTrialValue
            )
        }
    }
}

private extension LoadSubscriptionPlanItemsUseCase {
    func resolvePlanUnit(for periodUnit: SubscriptionStoreProductPeriodUnit) -> SubscriptionPlanUnit {
        switch periodUnit {
        case .day:
            .day
        case .week:
            .week
        case .month:
            .month
        case .year:
            .year
        case .unknown:
            .unknown
        }
    }

    func resolveTitleKey(for plan: SubscriptionPlan) -> String? {
        switch plan {
        case .yearly:
            "subscription.plan.yearly"
        case .monthly:
            "subscription.plan.monthly"
        case .weekly:
            "subscription.plan.weekly"
        case .unknown:
            nil
        }
    }

    func weeklyEquivalentPrice(for product: SubscriptionStoreProduct) -> Decimal? {
        let periodValue = Decimal(product.periodValue)
        guard periodValue > 0 else {
            return nil
        }

        let weekCount: Decimal
        switch product.periodUnit {
        case .day:
            weekCount = periodValue / 7
        case .week:
            weekCount = periodValue
        case .month:
            weekCount = periodValue * Decimal(string: "4.34524")!
        case .year:
            weekCount = periodValue * 52
        case .unknown:
            return nil
        }

        guard weekCount > 0 else {
            return nil
        }

        return product.price / weekCount
    }

    func resolveSavePercent(
        candidateWeeklyPrice: Decimal?,
        baselineWeeklyPrice: Decimal?
    ) -> Int? {
        guard let candidateWeeklyPrice,
              let baselineWeeklyPrice,
              baselineWeeklyPrice > 0,
              baselineWeeklyPrice > candidateWeeklyPrice
        else {
            return nil
        }

        let savedRatio = (baselineWeeklyPrice - candidateWeeklyPrice) / baselineWeeklyPrice
        let percent = NSDecimalNumber(decimal: savedRatio)
            .multiplying(by: NSDecimalNumber(value: 100))
            .doubleValue
        return max(1, Int(percent.rounded()))
    }

    func formatCurrency(
        _ value: Decimal,
        currencyCode: String?,
        locale: Locale
    ) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = locale
        if let currencyCode {
            formatter.currencyCode = currencyCode
        }

        return formatter.string(from: NSDecimalNumber(decimal: value))
            ?? NSDecimalNumber(decimal: value).stringValue
    }
}
