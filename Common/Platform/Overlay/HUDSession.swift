import Foundation

@MainActor
final class HUDHandle {
    fileprivate weak var session: HUDSession?
    let id: UUID

    fileprivate init(session: HUDSession, id: UUID = UUID()) {
        self.session = session
        self.id = id
    }

    func update(
        text: OverlayText? = nil,
        progress: Double? = nil,
        style: OverlayStyle? = nil,
        iconName: String? = nil
    ) {
        session?.update(
            hudID: id,
            text: text,
            progress: progress,
            style: style,
            iconName: iconName
        )
    }

    func hide() {
        session?.hide(hudID: id)
    }
}

@MainActor
final class HUDSession {
    let id = UUID()
    let scope: OverlayScope
    weak var store: OverlayStore?
    private(set) var isInvalidated = false

    init(store: OverlayStore, scope: OverlayScope) {
        self.store = store
        self.scope = scope
    }

    @discardableResult
    func show(
        style: OverlayStyle,
        text: OverlayText,
        iconName: String? = nil,
        progress: Double? = nil,
        dimBackground: Bool = false,
        tapToDismiss: Bool = false
    ) -> HUDHandle {
        let handle = HUDHandle(session: self)
        guard isInvalidated == false else {
            return handle
        }

        store?.presentHUD(
            id: handle.id,
            sessionID: id,
            scope: scope,
            style: style,
            text: text,
            iconName: iconName,
            progress: progress,
            dimBackground: dimBackground,
            tapToDismiss: tapToDismiss
        )

        return handle
    }

    @discardableResult
    func showLoading(
        _ text: OverlayText,
        dimBackground: Bool = false
    ) -> HUDHandle {
        show(style: .loading, text: text, dimBackground: dimBackground)
    }

    @discardableResult
    func showSearching(
        _ text: OverlayText,
        dimBackground: Bool = false
    ) -> HUDHandle {
        show(style: .searching, text: text, dimBackground: dimBackground)
    }

    @discardableResult
    func showProcessing(
        _ text: OverlayText,
        progress: Double? = nil,
        dimBackground: Bool = false
    ) -> HUDHandle {
        show(style: .processing, text: text, progress: progress, dimBackground: dimBackground)
    }

    func invalidate() {
        guard isInvalidated == false else {
            return
        }

        isInvalidated = true
        store?.invalidateHUDSession(id)
    }

    fileprivate func update(
        hudID: UUID,
        text: OverlayText? = nil,
        progress: Double? = nil,
        style: OverlayStyle? = nil,
        iconName: String? = nil
    ) {
        guard isInvalidated == false else {
            return
        }

        store?.updateHUD(
            sessionID: id,
            hudID: hudID,
            text: text,
            progress: progress,
            style: style,
            iconName: iconName
        )
    }

    fileprivate func hide(hudID: UUID) {
        guard isInvalidated == false else {
            return
        }

        store?.hideHUD(sessionID: id, hudID: hudID)
    }
}
