import Foundation

struct OverlayPresenterModel: Equatable {
    struct Banner: Identifiable, Equatable {
        let id: UUID
        let scope: OverlayScope
        let iconName: String
        let text: TextContent
        let tapToDismiss: Bool
    }

    struct HUD: Identifiable, Equatable {
        let id: UUID
        let scope: OverlayScope
        let iconName: String
        let title: TextContent
        let message: TextContent?
        let progress: Double?
        let usesIndeterminateProgress: Bool
        let dimBackground: Bool
        let tapToDismiss: Bool
    }

    enum TextContent: Equatable {
        case key(String)
        case verbatim(String)
    }

    let banner: Banner?
    let hud: HUD?
}
