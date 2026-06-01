import Foundation

enum FeedbackRoute: Equatable, Sendable {
    case composer(recipient: String, subject: String)
    case externalURL(URL)
    case unavailable
}

@MainActor
protocol SupportActionRepositoryProtocol: Sendable {
    func makeReviewURL() -> URL?
    func makeShareURL() -> URL?
    func makeFeedbackRoute(subject: String) -> FeedbackRoute
}
