import Foundation

enum PageSecondaryState: Equatable, Sendable {
    case idle
    case refreshing
    case loadingMore
    case refreshError(message: LocalizedStringResource)
    case loadMoreError(message: LocalizedStringResource)
}
