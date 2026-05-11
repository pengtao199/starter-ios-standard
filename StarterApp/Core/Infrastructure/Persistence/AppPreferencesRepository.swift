import Foundation

@MainActor
final class AppPreferencesRepository: AppPreferencesRepositoryProtocol {
    private enum Keys {
        static let appearance = "starter.preferences.appearance"
        static let language = "starter.preferences.language"
    }

    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func loadPreferences() -> AppPreferences {
        AppPreferences(
            appearance: AppAppearance(
                rawValue: userDefaults.string(forKey: Keys.appearance) ?? AppAppearance.system.rawValue
            ) ?? .system,
            language: AppLanguage(
                rawValue: userDefaults.string(forKey: Keys.language) ?? AppLanguage.system.rawValue
            ) ?? .system
        )
    }

    func updateAppearance(_ appearance: AppAppearance) {
        userDefaults.set(appearance.rawValue, forKey: Keys.appearance)
    }

    func updateLanguage(_ language: AppLanguage) {
        userDefaults.set(language.rawValue, forKey: Keys.language)
    }
}
