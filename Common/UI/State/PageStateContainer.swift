import SwiftUI

struct PageStateContainer<Content: Sendable, ContentView: View, SkeletonView: View>: View {
    let primaryState: PagePrimaryState<Content>
    let secondaryState: PageSecondaryState
    let loadingTitle: LocalizedStringResource
    let retryAction: (() -> Void)?
    private let contentBuilder: (Content) -> ContentView
    private let skeletonBuilder: () -> SkeletonView

    init(
        primaryState: PagePrimaryState<Content>,
        secondaryState: PageSecondaryState = .idle,
        loadingTitle: LocalizedStringResource = "common.state.loading",
        retryAction: (() -> Void)? = nil,
        @ViewBuilder content: @escaping (Content) -> ContentView,
        @ViewBuilder skeleton: @escaping () -> SkeletonView
    ) {
        self.primaryState = primaryState
        self.secondaryState = secondaryState
        self.loadingTitle = loadingTitle
        self.retryAction = retryAction
        self.contentBuilder = content
        self.skeletonBuilder = skeleton
    }

    var body: some View {
        switch primaryState {
        case .skeleton:
            skeletonBuilder()
        case .loading:
            stateContainer {
                ProgressView(loadingTitle)
                    .controlSize(.large)
            }
        case let .content(content):
            contentBuilder(content)
        case let .empty(emptyState):
            stateContainer {
                ContentUnavailableView {
                    Label(emptyState.title, systemImage: emptyState.systemImage)
                } description: {
                    Text(emptyState.message)
                }
            }
        case let .error(errorState):
            stateContainer {
                ContentUnavailableView {
                    Label(errorState.title, systemImage: errorState.systemImage)
                } description: {
                    Text(errorState.message)
                } actions: {
                    if let retryAction {
                        Button(errorState.retryTitle, action: retryAction)
                    }
                }
            }
        }
    }

    private func stateContainer<InnerContent: View>(
        @ViewBuilder content: () -> InnerContent
    ) -> some View {
        VStack {
            content()
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, minHeight: 240, alignment: .center)
    }
}
