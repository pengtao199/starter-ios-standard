import Foundation

@MainActor
final class AppContainer {
    let appEnvironment: AppEnvironment

    init() {
        let appConfig = AppConfig.default
        let supportConfig = SupportConfig.default
        let legalConfig = LegalConfig.default
        let subscriptionConfig = SubscriptionConfig.default

        let overlayStore = OverlayStore()
        let appPreferencesRepository = AppPreferencesRepository()
        let subscriptionStateRepository = SubscriptionStateRepository()
        let supportActionRepository = SupportActionRepository(supportConfig: supportConfig)
        let legalDocumentResolver = ResolveLegalDocumentUseCase(legalConfig: legalConfig)
        let subscriptionStoreKitRepository = StoreKitSubscriptionRepository(
            storefrontConfiguration: subscriptionConfig.storefrontConfiguration
        )

        let loadAppPreferencesUseCase = LoadAppPreferencesUseCase(
            appPreferencesRepository: appPreferencesRepository
        )
        let updateAppAppearanceUseCase = UpdateAppAppearanceUseCase(
            appPreferencesRepository: appPreferencesRepository
        )
        let updateAppLanguageUseCase = UpdateAppLanguageUseCase(
            appPreferencesRepository: appPreferencesRepository
        )
        let loadSubscriptionAccessUseCase = LoadSubscriptionAccessUseCase(
            subscriptionStateRepository: subscriptionStateRepository,
            storefrontConfiguration: subscriptionConfig.storefrontConfiguration
        )
        let refreshSubscriptionStatusUseCase = RefreshSubscriptionStatusUseCase(
            subscriptionStoreKitRepository: subscriptionStoreKitRepository,
            subscriptionStateRepository: subscriptionStateRepository
        )
        let restoreSubscriptionPurchasesUseCase = RestoreSubscriptionPurchasesUseCase(
            subscriptionStoreKitRepository: subscriptionStoreKitRepository,
            refreshSubscriptionStatusUseCase: refreshSubscriptionStatusUseCase
        )
        let loadSubscriptionViewStateUseCase = LoadSubscriptionViewStateUseCase(
            loadSubscriptionAccessUseCase: loadSubscriptionAccessUseCase,
            subscriptionConfig: subscriptionConfig
        )
        let loadSubscriptionPlanItemsUseCase = LoadSubscriptionPlanItemsUseCase(
            subscriptionStoreKitRepository: subscriptionStoreKitRepository,
            storefrontConfiguration: subscriptionConfig.storefrontConfiguration
        )
        let purchaseSubscriptionPlanUseCase = PurchaseSubscriptionPlanUseCase(
            subscriptionStoreKitRepository: subscriptionStoreKitRepository,
            refreshSubscriptionStatusUseCase: refreshSubscriptionStatusUseCase
        )

        let settingsStore = SettingsStore(
            loadSettingsUseCase: LoadSettingsUseCase(
                appConfig: appConfig,
                loadAppPreferencesUseCase: loadAppPreferencesUseCase
            ),
            loadSettingsCacheSummaryUseCase: LoadSettingsCacheSummaryUseCase(
                settingsCacheRepository: NoopSettingsCacheRepository()
            ),
            updateSettingsAppearanceUseCase: UpdateSettingsAppearanceUseCase(
                updateAppAppearanceUseCase: updateAppAppearanceUseCase
            ),
            updateSettingsLanguageUseCase: UpdateSettingsLanguageUseCase(
                updateAppLanguageUseCase: updateAppLanguageUseCase
            ),
            clearSettingsCacheUseCase: ClearSettingsCacheUseCase(
                settingsCacheRepository: NoopSettingsCacheRepository()
            ),
            prepareAppReviewURLUseCase: PrepareAppReviewURLUseCase(
                supportActionRepository: supportActionRepository
            ),
            prepareAppShareUseCase: PrepareAppShareUseCase(
                supportActionRepository: supportActionRepository
            ),
            prepareAppFeedbackRouteUseCase: PrepareAppFeedbackRouteUseCase(
                supportActionRepository: supportActionRepository
            ),
            restoreSubscriptionPurchasesUseCase: restoreSubscriptionPurchasesUseCase,
            resolveLegalDocumentUseCase: legalDocumentResolver,
            overlayStore: overlayStore
        )

        let subscriptionStore = SubscriptionStore(
            loadSubscriptionViewStateUseCase: loadSubscriptionViewStateUseCase,
            loadSubscriptionPlanItemsUseCase: loadSubscriptionPlanItemsUseCase,
            purchaseSubscriptionPlanUseCase: purchaseSubscriptionPlanUseCase,
            refreshSubscriptionStatusUseCase: refreshSubscriptionStatusUseCase,
            restoreSubscriptionPurchasesUseCase: restoreSubscriptionPurchasesUseCase,
            resolveLegalDocumentUseCase: legalDocumentResolver
        )

        let homeStore = HomeStore(overlayStore: overlayStore)

        self.appEnvironment = AppEnvironment(
            appConfig: appConfig,
            supportConfig: supportConfig,
            legalConfig: legalConfig,
            subscriptionConfig: subscriptionConfig,
            overlayStore: overlayStore,
            homeStore: homeStore,
            settingsStore: settingsStore,
            subscriptionStore: subscriptionStore
        )
    }
}
