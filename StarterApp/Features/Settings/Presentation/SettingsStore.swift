import Foundation
import Observation

@MainActor
@Observable
final class SettingsStore {
    @ObservationIgnored
    private let loadSettingsCacheSummaryUseCase: LoadSettingsCacheSummaryUseCase
    @ObservationIgnored
    private let updateSettingsAppearanceUseCase: UpdateSettingsAppearanceUseCase
    @ObservationIgnored
    private let updateSettingsLanguageUseCase: UpdateSettingsLanguageUseCase
    @ObservationIgnored
    private let clearSettingsCacheUseCase: ClearSettingsCacheUseCase
    @ObservationIgnored
    private let prepareAppReviewURLUseCase: PrepareAppReviewURLUseCase
    @ObservationIgnored
    private let prepareAppShareUseCase: PrepareAppShareUseCase
    @ObservationIgnored
    private let prepareAppFeedbackRouteUseCase: PrepareAppFeedbackRouteUseCase
    @ObservationIgnored
    private let restoreSubscriptionPurchasesUseCase: RestoreSubscriptionPurchasesUseCase
    @ObservationIgnored
    private let resolveLegalDocumentUseCase: ResolveLegalDocumentUseCase
    @ObservationIgnored
    private let overlayStore: OverlayStore

    private(set) var content: SettingsContent
    var selectedAppearance: AppAppearance
    var selectedLanguage: AppLanguage
    private(set) var cacheSummary: SettingsCacheSummary = .zero
    private(set) var isClearingCache = false
    private(set) var isRestoringPurchases = false
    private(set) var presentedFullScreenCover: SettingsFullScreenDestination?
    private(set) var presentedSheet: SettingsSheetDestination?
    private(set) var pendingExternalURL: URL?
    @ObservationIgnored
    private var hasLoadedCacheSummary = false

    init(
        loadSettingsUseCase: LoadSettingsUseCase,
        loadSettingsCacheSummaryUseCase: LoadSettingsCacheSummaryUseCase,
        updateSettingsAppearanceUseCase: UpdateSettingsAppearanceUseCase,
        updateSettingsLanguageUseCase: UpdateSettingsLanguageUseCase,
        clearSettingsCacheUseCase: ClearSettingsCacheUseCase,
        prepareAppReviewURLUseCase: PrepareAppReviewURLUseCase,
        prepareAppShareUseCase: PrepareAppShareUseCase,
        prepareAppFeedbackRouteUseCase: PrepareAppFeedbackRouteUseCase,
        restoreSubscriptionPurchasesUseCase: RestoreSubscriptionPurchasesUseCase,
        resolveLegalDocumentUseCase: ResolveLegalDocumentUseCase,
        overlayStore: OverlayStore
    ) {
        self.loadSettingsCacheSummaryUseCase = loadSettingsCacheSummaryUseCase
        self.updateSettingsAppearanceUseCase = updateSettingsAppearanceUseCase
        self.updateSettingsLanguageUseCase = updateSettingsLanguageUseCase
        self.clearSettingsCacheUseCase = clearSettingsCacheUseCase
        self.prepareAppReviewURLUseCase = prepareAppReviewURLUseCase
        self.prepareAppShareUseCase = prepareAppShareUseCase
        self.prepareAppFeedbackRouteUseCase = prepareAppFeedbackRouteUseCase
        self.restoreSubscriptionPurchasesUseCase = restoreSubscriptionPurchasesUseCase
        self.resolveLegalDocumentUseCase = resolveLegalDocumentUseCase
        self.overlayStore = overlayStore

        let content = loadSettingsUseCase.execute()
        self.content = content
        self.selectedAppearance = content.currentAppearance
        self.selectedLanguage = content.currentLanguage
    }

    var cacheSummaryText: String {
        cacheSummary.totalBytes.formatted(.byteCount(style: .file))
    }

    func setAppearance(_ appearance: AppAppearance) {
        guard selectedAppearance != appearance else {
            return
        }

        selectedAppearance = appearance
        updateSettingsAppearanceUseCase.execute(appearance)
    }

    func setLanguage(_ language: AppLanguage) {
        guard selectedLanguage != language else {
            return
        }

        selectedLanguage = language
        updateSettingsLanguageUseCase.execute(language)
    }

    func clearCache() async {
        guard isClearingCache == false else {
            return
        }

        isClearingCache = true
        let session = overlayStore.makeHUDSession()
        _ = session.showLoading(.key("settings.cache.clearing"))

        defer {
            session.invalidate()
            isClearingCache = false
        }

        do {
            let result = try await clearSettingsCacheUseCase.execute()
            cacheSummary = SettingsCacheSummary(totalBytes: max(0, cacheSummary.totalBytes - result.freedBytes))
            overlayStore.showBannerSuccess(.key("settings.cache.cleared"))
        } catch {
            overlayStore.showBannerError(.key("settings.action.unavailable"))
        }
    }

    func requestReview() {
        guard let reviewURL = prepareAppReviewURLUseCase.execute() else {
            overlayStore.showBannerError(.key("settings.action.unavailable"))
            return
        }

        pendingExternalURL = reviewURL
    }

    func prepareShare() {
        guard let shareURL = prepareAppShareUseCase.execute() else {
            overlayStore.showBannerError(.key("settings.action.unavailable"))
            return
        }

        presentedSheet = .share(url: shareURL)
    }

    func openFeedback() {
        switch prepareAppFeedbackRouteUseCase.execute() {
        case let .composer(recipient, subject):
            presentedSheet = .feedbackComposer(recipient: recipient, subject: subject)
        case let .externalURL(url):
            pendingExternalURL = url
        case .unavailable:
            overlayStore.showBannerError(.key("settings.action.unavailable"))
        }
    }

    func presentLegalDocument(_ type: LegalDocumentType) {
        presentedSheet = .legalDocument(type)
    }

    func presentSubscription() {
        presentedFullScreenCover = .subscription
    }

    func restorePurchases() async {
        guard isRestoringPurchases == false else {
            return
        }

        isRestoringPurchases = true
        let session = overlayStore.makeHUDSession()
        _ = session.showLoading(.key("settings.restore.loading"))

        defer {
            session.invalidate()
            isRestoringPurchases = false
        }

        do {
            _ = try await restoreSubscriptionPurchasesUseCase.execute()
            overlayStore.showBannerSuccess(.key("settings.restore.success"))
        } catch {
            overlayStore.showBannerError(.key("settings.restore.failed"))
        }
    }

    func consumePendingExternalURL() -> URL? {
        defer { pendingExternalURL = nil }
        return pendingExternalURL
    }

    func dismissPresentedSheet() {
        presentedSheet = nil
    }

    func dismissPresentedFullScreenCover() {
        presentedFullScreenCover = nil
    }

    func loadCacheSummaryIfNeeded() async {
        guard hasLoadedCacheSummary == false else {
            return
        }

        hasLoadedCacheSummary = true
        cacheSummary = await loadSettingsCacheSummaryUseCase.execute()
    }

    func legalDocumentStore(for type: LegalDocumentType) -> LegalDocumentStore {
        LegalDocumentStore(
            type: type,
            resolveLegalDocumentUseCase: resolveLegalDocumentUseCase
        )
    }
}
