import Observation

@MainActor
@Observable
final class HomeStore {
    @ObservationIgnored
    private let overlayStore: OverlayStore

    private(set) var primaryState: PagePrimaryState<[HomeDemoItem]> = .content(HomeStore.defaultItems)
    private(set) var secondaryState: PageSecondaryState = .idle
    private(set) var isProgressHUDVisible = false

    init(overlayStore: OverlayStore) {
        self.overlayStore = overlayStore
    }

    func showContent() {
        primaryState = .content(Self.defaultItems)
        secondaryState = .idle
    }

    func showSkeleton() {
        primaryState = .skeleton
        secondaryState = .idle
    }

    func showLoading() {
        primaryState = .loading
        secondaryState = .idle
    }

    func showEmpty() {
        primaryState = .empty(
            PageEmptyState(
                title: "home.empty.title",
                message: "home.empty.message",
                systemImage: "square.stack.3d.up.slash"
            )
        )
        secondaryState = .idle
    }

    func showError() {
        primaryState = .error(
            PageErrorState(
                title: "home.error.title",
                message: "home.error.message"
            )
        )
        secondaryState = .idle
    }

    func showRefreshError() {
        primaryState = .content(Self.defaultItems)
        secondaryState = .refreshError(message: "home.refresh.error")
    }

    func showSuccessBanner() {
        overlayStore.showBannerSuccess(.key("common.demo.banner.success"))
    }

    func showErrorBanner() {
        overlayStore.showBannerError(.key("common.demo.banner.error"))
    }

    func showLoadingHUD() {
        let session = overlayStore.makeHUDSession()
        _ = session.showLoading(.key("common.demo.hud.loading"))

        Task {
            try? await Task.sleep(for: .seconds(1.2))
            session.invalidate()
        }
    }

    func showProgressHUD() {
        let session = overlayStore.makeHUDSession()
        let handle = session.showProcessing(.key("common.demo.hud.processing"), progress: 0.2)

        Task {
            for progress in stride(from: 0.4, through: 1.0, by: 0.2) {
                try? await Task.sleep(for: .seconds(0.35))
                handle.update(progress: progress)
            }
            session.invalidate()
            overlayStore.showBannerSuccess(.key("common.demo.banner.complete"))
        }
    }
}

private extension HomeStore {
    static let defaultItems: [HomeDemoItem] = [
        HomeDemoItem(
            titleKey: "home.demo.overlay.title",
            descriptionKey: "home.demo.overlay.message"
        ),
        HomeDemoItem(
            titleKey: "home.demo.page_state.title",
            descriptionKey: "home.demo.page_state.message"
        ),
        HomeDemoItem(
            titleKey: "home.demo.settings.title",
            descriptionKey: "home.demo.settings.message"
        )
    ]
}
