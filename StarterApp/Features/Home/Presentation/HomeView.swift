import SwiftUI

struct HomeView: View {
    @Bindable var store: HomeStore

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: LayoutToken.sectionSpacing) {
                controlPanel
                pageStatePreview
            }
            .padding(LayoutToken.pageInset)
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle("common.tab.home")
        .navigationBarTitleDisplayMode(.large)
    }
}

private extension HomeView {
    var controlPanel: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("home.controls.title")
                .font(.headline)

            Text("home.controls.subtitle")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            LazyVGrid(columns: [.init(.flexible()), .init(.flexible())], spacing: 10) {
                actionButton("home.action.content", systemImage: "checkmark.rectangle") { store.showContent() }
                actionButton("home.action.skeleton", systemImage: "square.stack.3d.up") { store.showSkeleton() }
                actionButton("home.action.loading", systemImage: "hourglass") { store.showLoading() }
                actionButton("home.action.empty", systemImage: "tray") { store.showEmpty() }
                actionButton("home.action.error", systemImage: "wifi.exclamationmark") { store.showError() }
                actionButton("home.action.refresh_error", systemImage: "arrow.clockwise.circle") { store.showRefreshError() }
                actionButton("home.action.banner_success", systemImage: "checkmark.circle") { store.showSuccessBanner() }
                actionButton("home.action.banner_error", systemImage: "xmark.circle") { store.showErrorBanner() }
                actionButton("home.action.hud_loading", systemImage: "arrow.clockwise") { store.showLoadingHUD() }
                actionButton("home.action.hud_progress", systemImage: "chart.line.uptrend.xyaxis") { store.showProgressHUD() }
            }
        }
        .padding(LayoutToken.cardPadding)
        .background(
            RoundedRectangle(cornerRadius: LayoutToken.cardCornerRadius, style: .continuous)
                .fill(Color(uiColor: .secondarySystemGroupedBackground))
        )
    }

    var pageStatePreview: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("home.preview.title")
                .font(.headline)

            PageStateContainer(
                primaryState: store.primaryState,
                secondaryState: store.secondaryState,
                retryAction: store.showContent
            ) { items in
                VStack(spacing: 12) {
                    ForEach(items) { item in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(LocalizedStringKey(item.titleKey))
                                .font(.headline)

                            Text(LocalizedStringKey(item.descriptionKey))
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(LayoutToken.cardPadding)
                        .background(
                            RoundedRectangle(cornerRadius: LayoutToken.cardCornerRadius, style: .continuous)
                                .fill(Color(uiColor: .secondarySystemGroupedBackground))
                        )
                    }
                }
            } skeleton: {
                VStack(spacing: 12) {
                    ForEach(0 ..< 3, id: \.self) { _ in
                        RoundedRectangle(cornerRadius: LayoutToken.cardCornerRadius, style: .continuous)
                            .fill(Color(uiColor: .secondarySystemGroupedBackground))
                            .frame(height: 88)
                            .redacted(reason: .placeholder)
                    }
                }
            }
        }
    }

    func actionButton(
        _ titleKey: String,
        systemImage: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Label(LocalizedStringKey(titleKey), systemImage: systemImage)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
    }
}

#Preview {
    NavigationStack {
        HomeView(store: HomeStore(overlayStore: OverlayStore()))
    }
}
