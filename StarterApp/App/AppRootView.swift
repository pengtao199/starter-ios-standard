import SwiftUI

struct AppRootView: View {
    let appEnvironment: AppEnvironment

    var body: some View {
        ZStack {
            TabView {
                Tab("common.tab.home", systemImage: "house") {
                    NavigationStack {
                        HomeView(store: appEnvironment.homeStore)
                    }
                }

                Tab("common.tab.settings", systemImage: "gearshape") {
                    NavigationStack {
                        SettingsView(
                            store: appEnvironment.settingsStore,
                            subscriptionStore: appEnvironment.subscriptionStore
                        )
                    }
                }
            }

            OverlayPresenterView(
                model: overlayPresenterModel,
                scope: .root,
                onDismissBanner: { appEnvironment.overlayStore.hideBanner(scope: .root) },
                onDismissHUD: { appEnvironment.overlayStore.hideHUD(scope: .root) }
            )
        }
        .id("root_language_\(appEnvironment.settingsStore.selectedLanguage.rawValue)")
        .preferredColorScheme(appEnvironment.settingsStore.selectedAppearance.colorScheme)
        .environment(\.locale, appEnvironment.settingsStore.selectedLanguage.locale)
        .task {
            await appEnvironment.subscriptionStore.refreshStatus()
        }
    }
}

private extension AppRootView {
    var overlayPresenterModel: OverlayPresenterModel {
        OverlayPresenterModel(
            banner: bannerPresentation,
            hud: hudPresentation
        )
    }

    var bannerPresentation: OverlayPresenterModel.Banner? {
        guard let banner = appEnvironment.overlayStore.currentBanner else {
            return nil
        }

        return OverlayPresenterModel.Banner(
            id: banner.id,
            scope: banner.scope,
            iconName: banner.iconName,
            text: overlayText(from: banner.text),
            tapToDismiss: banner.tapToDismiss
        )
    }

    var hudPresentation: OverlayPresenterModel.HUD? {
        guard let hud = appEnvironment.overlayStore.currentHUD else {
            return nil
        }

        return OverlayPresenterModel.HUD(
            id: hud.id,
            scope: hud.scope,
            iconName: hud.iconName,
            title: .key(hud.style.titleKey),
            message: secondaryText(for: hud),
            progress: hud.progress,
            usesIndeterminateProgress: hud.style.usesIndeterminateProgress,
            dimBackground: hud.dimBackground,
            tapToDismiss: hud.tapToDismiss
        )
    }

    func overlayText(from text: OverlayText) -> OverlayPresenterModel.TextContent {
        switch text {
        case let .key(key):
            .key(key)
        case let .verbatim(value):
            .verbatim(value)
        }
    }

    func secondaryText(for message: OverlayMessage) -> OverlayPresenterModel.TextContent? {
        let resolvedText = overlayText(from: message.text)
        let title = OverlayPresenterModel.TextContent.key(message.style.titleKey)
        return resolvedText == title ? nil : resolvedText
    }
}

#Preview {
    AppRootView(appEnvironment: AppContainer().appEnvironment)
}
