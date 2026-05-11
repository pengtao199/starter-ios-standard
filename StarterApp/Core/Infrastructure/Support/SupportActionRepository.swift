import Foundation
import MessageUI

struct SupportActionRepository: SupportActionRepositoryProtocol {
    let supportConfig: SupportConfig

    func makeReviewURL() -> URL? {
        guard supportConfig.appStoreID.isEmpty == false else {
            return nil
        }

        return URL(
            string: "itms-apps://itunes.apple.com/app/id\(supportConfig.appStoreID)?action=write-review"
        )
    }

    func makeShareURL() -> URL? {
        supportConfig.shareURL
    }

    func makeFeedbackRoute(subject: String) -> FeedbackRoute {
        if MFMailComposeViewController.canSendMail() {
            return .composer(
                recipient: supportConfig.supportEmail,
                subject: subject
            )
        }

        guard
            let encodedSubject = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: "mailto:\(supportConfig.supportEmail)?subject=\(encodedSubject)")
        else {
            return .unavailable
        }

        return .externalURL(url)
    }
}
