import Foundation

struct SettingsContent: Equatable, Sendable {
    let titleKey: String
    let appName: String
    let appVersionText: String
    let currentAppearance: AppAppearance
    let currentLanguage: AppLanguage
    let appearanceOptions: [SettingsAppearanceOption]
    let languageOptions: [SettingsLanguageOption]
    let subscriptionItem: SettingsRowItem
    let clearCacheItem: SettingsRowItem
    let rateItem: SettingsRowItem
    let shareItem: SettingsRowItem
    let feedbackItem: SettingsRowItem
    let legalItems: [SettingsLegalItem]
    let restorePurchaseItem: SettingsRowItem
}

struct SettingsAppearanceOption: Identifiable, Equatable, Sendable {
    let value: AppAppearance
    let titleKey: String

    var id: AppAppearance {
        value
    }
}

struct SettingsLanguageOption: Identifiable, Equatable, Sendable {
    let value: AppLanguage
    let titleKey: String

    var id: AppLanguage {
        value
    }
}

struct SettingsRowItem: Identifiable, Equatable, Sendable {
    let titleKey: String
    let systemImage: String

    var id: String {
        titleKey
    }
}

struct SettingsLegalItem: Identifiable, Equatable, Sendable {
    let type: LegalDocumentType
    let titleKey: String
    let systemImage: String

    var id: LegalDocumentType {
        type
    }
}

struct SettingsCacheClearResult: Equatable, Sendable {
    let freedBytes: Int64
}

struct SettingsCacheSummary: Equatable, Sendable {
    let totalBytes: Int64

    static let zero = SettingsCacheSummary(totalBytes: 0)
}
