import SwiftUI

@main
@MainActor
struct StarterApp: App {
    @State private var appContainer = AppContainer()

    var body: some Scene {
        WindowGroup {
            AppRootView(appEnvironment: appContainer.appEnvironment)
        }
    }
}
