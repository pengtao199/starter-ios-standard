import Foundation
import Observation

@MainActor
@Observable
final class SubscriptionStore {
    @ObservationIgnored
    private let loadSubscriptionViewStateUseCase: LoadSubscriptionViewStateUseCase
    @ObservationIgnored
    private let loadSubscriptionPlanItemsUseCase: LoadSubscriptionPlanItemsUseCase
    @ObservationIgnored
    private let purchaseSubscriptionPlanUseCase: PurchaseSubscriptionPlanUseCase
    @ObservationIgnored
    private let refreshSubscriptionStatusUseCase: RefreshSubscriptionStatusUseCase
    @ObservationIgnored
    private let restoreSubscriptionPurchasesUseCase: RestoreSubscriptionPurchasesUseCase
    @ObservationIgnored
    private let resolveLegalDocumentUseCase: ResolveLegalDocumentUseCase

    private(set) var content: SubscriptionViewContent
    private(set) var planItems: [SubscriptionPlanItem] = []
    private(set) var selectedProductID: String?
    private(set) var isLoadingPlans = false
    private(set) var isPurchasing = false
    private(set) var isRestoringPurchases = false
    private(set) var alertMessageKey: String?
    private(set) var planLoadErrorKey: String?
    private(set) var presentedLegalDocument: LegalDocumentType?
    @ObservationIgnored
    private var hasLoadedPlans = false
    @ObservationIgnored
    private var loadedPlanLocaleIdentifier: String?

    init(
        loadSubscriptionViewStateUseCase: LoadSubscriptionViewStateUseCase,
        loadSubscriptionPlanItemsUseCase: LoadSubscriptionPlanItemsUseCase,
        purchaseSubscriptionPlanUseCase: PurchaseSubscriptionPlanUseCase,
        refreshSubscriptionStatusUseCase: RefreshSubscriptionStatusUseCase,
        restoreSubscriptionPurchasesUseCase: RestoreSubscriptionPurchasesUseCase,
        resolveLegalDocumentUseCase: ResolveLegalDocumentUseCase
    ) {
        self.loadSubscriptionViewStateUseCase = loadSubscriptionViewStateUseCase
        self.loadSubscriptionPlanItemsUseCase = loadSubscriptionPlanItemsUseCase
        self.purchaseSubscriptionPlanUseCase = purchaseSubscriptionPlanUseCase
        self.refreshSubscriptionStatusUseCase = refreshSubscriptionStatusUseCase
        self.restoreSubscriptionPurchasesUseCase = restoreSubscriptionPurchasesUseCase
        self.resolveLegalDocumentUseCase = resolveLegalDocumentUseCase
        self.content = loadSubscriptionViewStateUseCase.execute()
    }

    var selectedPlanItem: SubscriptionPlanItem? {
        guard let selectedProductID else {
            return nil
        }

        return planItems.first(where: { $0.productID == selectedProductID })
    }

    var isPrimaryActionDisabled: Bool {
        content.isSubscriptionActive || isLoadingPlans || isPurchasing || isRestoringPurchases || selectedProductID == nil
    }

    func handleAppear(locale: Locale) async {
        await refreshStatus()
        await loadPlansIfNeeded(locale: locale)
    }

    func refreshStatus() async {
        _ = await refreshSubscriptionStatusUseCase.execute()
        content = loadSubscriptionViewStateUseCase.execute()
    }

    func selectPlan(productID: String) {
        selectedProductID = productID
    }

    func purchaseSelectedPlan() async {
        guard isPurchasing == false, let selectedProductID else {
            return
        }

        isPurchasing = true
        defer { isPurchasing = false }

        do {
            let result = try await purchaseSubscriptionPlanUseCase.execute(productID: selectedProductID)
            switch result {
            case .success:
                await refreshStatus()
                alertMessageKey = nil
            case .pending:
                alertMessageKey = "subscription.purchase.pending"
            case .cancelled:
                break
            }
        } catch {
            alertMessageKey = "subscription.purchase.failed"
        }
    }

    func restorePurchases() async {
        guard isRestoringPurchases == false else {
            return
        }

        isRestoringPurchases = true
        defer { isRestoringPurchases = false }

        do {
            _ = try await restoreSubscriptionPurchasesUseCase.execute()
            await refreshStatus()
            alertMessageKey = "subscription.restore.success"
        } catch {
            alertMessageKey = "subscription.restore.failed"
        }
    }

    func dismissAlert() {
        alertMessageKey = nil
    }

    func presentLegalDocument(_ type: LegalDocumentType) {
        presentedLegalDocument = type
    }

    func dismissPresentedLegalDocument() {
        presentedLegalDocument = nil
    }

    func legalDocumentStore(for type: LegalDocumentType) -> LegalDocumentStore {
        LegalDocumentStore(type: type, resolveLegalDocumentUseCase: resolveLegalDocumentUseCase)
    }

    private func loadPlansIfNeeded(locale: Locale) async {
        let localeIdentifier = locale.identifier
        if hasLoadedPlans, loadedPlanLocaleIdentifier == localeIdentifier {
            return
        }

        isLoadingPlans = true
        defer { isLoadingPlans = false }

        do {
            let items = try await loadSubscriptionPlanItemsUseCase.execute(locale: locale)
            hasLoadedPlans = true
            loadedPlanLocaleIdentifier = localeIdentifier
            planItems = items
            selectedProductID = resolveDefaultSelectedProductID(in: items)
            planLoadErrorKey = items.isEmpty ? "subscription.products.unavailable" : nil
        } catch {
            planItems = []
            selectedProductID = nil
            planLoadErrorKey = "subscription.products.failed"
        }
    }

    private func resolveDefaultSelectedProductID(in items: [SubscriptionPlanItem]) -> String? {
        if let defaultProductID = content.defaultProductID,
           items.contains(where: { $0.productID == defaultProductID }) {
            return defaultProductID
        }

        return items.first?.productID
    }
}
