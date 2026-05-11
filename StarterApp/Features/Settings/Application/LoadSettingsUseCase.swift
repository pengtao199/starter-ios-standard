import Foundation

struct LoadSettingsUseCase {
    private let appConfig: AppConfig
    private let loadAppPreferencesUseCase: LoadAppPreferencesUseCase

    init(
        appConfig: AppConfig,
        loadAppPreferencesUseCase: LoadAppPreferencesUseCase
    ) {
        self.appConfig = appConfig
        self.loadAppPreferencesUseCase = loadAppPreferencesUseCase
    }

    @MainActor
    func execute() -> SettingsContent {
        let preferences = loadAppPreferencesUseCase.execute()
        let bundle = Bundle.main
        let appName = bundle.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
            ?? bundle.object(forInfoDictionaryKey: "CFBundleName") as? String
            ?? appConfig.displayName
        let version = bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
            ?? appConfig.version
        let build = bundle.object(forInfoDictionaryKey: "CFBundleVersion") as? String
            ?? appConfig.buildNumber

        return SettingsContent(
            titleKey: "settings.title",
            appName: appName,
            appVersionText: "v\(version) (\(build))",
            currentAppearance: preferences.appearance,
            currentLanguage: preferences.language,
            appearanceOptions: [
                SettingsAppearanceOption(value: .system, titleKey: "settings.appearance.system"),
                SettingsAppearanceOption(value: .light, titleKey: "settings.appearance.light"),
                SettingsAppearanceOption(value: .dark, titleKey: "settings.appearance.dark")
            ],
            languageOptions: [
                SettingsLanguageOption(value: .system, titleKey: "settings.language.system"),
                SettingsLanguageOption(value: .simplifiedChinese, titleKey: "settings.language.zh"),
                SettingsLanguageOption(value: .english, titleKey: "settings.language.en")
            ],
            subscriptionItem: SettingsRowItem(titleKey: "settings.subscription", systemImage: "crown.fill"),
            clearCacheItem: SettingsRowItem(titleKey: "settings.clear_cache", systemImage: "trash"),
            rateItem: SettingsRowItem(titleKey: "settings.rate", systemImage: "star.bubble"),
            shareItem: SettingsRowItem(titleKey: "settings.share", systemImage: "square.and.arrow.up"),
            feedbackItem: SettingsRowItem(titleKey: "settings.feedback", systemImage: "envelope"),
            legalItems: [
                SettingsLegalItem(type: .terms, titleKey: "common.legal.terms", systemImage: "doc.text"),
                SettingsLegalItem(type: .privacy, titleKey: "common.legal.privacy", systemImage: "hand.raised")
            ],
            restorePurchaseItem: SettingsRowItem(titleKey: "settings.restore_purchases", systemImage: "arrow.clockwise")
        )
    }
}
