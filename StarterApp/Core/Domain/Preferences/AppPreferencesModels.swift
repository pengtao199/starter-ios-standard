import Foundation
import SwiftUI

enum AppAppearance: String, CaseIterable, Codable, Equatable, Sendable {
    case system
    case light
    case dark

    var colorScheme: ColorScheme? {
        switch self {
        case .system:
            nil
        case .light:
            .light
        case .dark:
            .dark
        }
    }
}

enum AppLanguage: String, CaseIterable, Codable, Equatable, Sendable {
    case system
    case simplifiedChinese = "zh-Hans"
    case english = "en"

    var locale: Locale {
        switch self {
        case .system:
            .autoupdatingCurrent
        case .simplifiedChinese:
            Locale(identifier: "zh-Hans")
        case .english:
            Locale(identifier: "en")
        }
    }
}

struct AppPreferences: Codable, Equatable, Sendable {
    let appearance: AppAppearance
    let language: AppLanguage

    static let `default` = AppPreferences(
        appearance: .system,
        language: .system
    )
}

@MainActor
protocol AppPreferencesRepositoryProtocol: Sendable {
    func loadPreferences() -> AppPreferences
    func updateAppearance(_ appearance: AppAppearance)
    func updateLanguage(_ language: AppLanguage)
}
