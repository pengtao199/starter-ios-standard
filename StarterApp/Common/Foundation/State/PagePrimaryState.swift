import Foundation

struct PageEmptyState: Equatable, Sendable {
    let title: LocalizedStringResource
    let message: LocalizedStringResource
    let systemImage: String
}

struct PageErrorState: Equatable, Sendable {
    let title: LocalizedStringResource
    let message: LocalizedStringResource
    let systemImage: String
    let retryTitle: LocalizedStringResource

    init(
        title: LocalizedStringResource,
        message: LocalizedStringResource,
        systemImage: String = "exclamationmark.triangle",
        retryTitle: LocalizedStringResource = "common.action.retry"
    ) {
        self.title = title
        self.message = message
        self.systemImage = systemImage
        self.retryTitle = retryTitle
    }
}

enum PagePrimaryState<Content: Sendable>: Sendable {
    case skeleton
    case loading
    case content(Content)
    case empty(PageEmptyState)
    case error(PageErrorState)
}

extension PagePrimaryState: Equatable where Content: Equatable {}
