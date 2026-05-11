import Foundation

@MainActor
final class AppEnvironment {
    let appConfig: AppConfig
    let supportConfig: SupportConfig
    let legalConfig: LegalConfig
    let subscriptionConfig: SubscriptionConfig
    let overlayStore: OverlayStore
    let homeStore: HomeStore
    let settingsStore: SettingsStore
    let subscriptionStore: SubscriptionStore

    init(
        appConfig: AppConfig,
        supportConfig: SupportConfig,
        legalConfig: LegalConfig,
        subscriptionConfig: SubscriptionConfig,
        overlayStore: OverlayStore,
        homeStore: HomeStore,
        settingsStore: SettingsStore,
        subscriptionStore: SubscriptionStore
    ) {
        self.appConfig = appConfig
        self.supportConfig = supportConfig
        self.legalConfig = legalConfig
        self.subscriptionConfig = subscriptionConfig
        self.overlayStore = overlayStore
        self.homeStore = homeStore
        self.settingsStore = settingsStore
        self.subscriptionStore = subscriptionStore
    }
}
