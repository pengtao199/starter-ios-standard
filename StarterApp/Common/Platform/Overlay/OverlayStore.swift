import Observation
import SwiftUI

enum OverlayScope: Equatable, Sendable {
    case root
    case modal(name: String)
}

enum OverlayKind: Equatable, Sendable {
    case banner
    case hud
}

enum OverlayStyle: String, CaseIterable, Equatable, Sendable {
    case success
    case error
    case warning
    case info
    case loading
    case searching
    case processing

    var defaultKind: OverlayKind {
        switch self {
        case .success, .error, .warning, .info:
            .banner
        case .loading, .searching, .processing:
            .hud
        }
    }

    var defaultIconName: String {
        switch self {
        case .success:
            "checkmark.circle.fill"
        case .error:
            "xmark.circle.fill"
        case .warning:
            "exclamationmark.triangle.fill"
        case .info:
            "info.circle.fill"
        case .loading, .processing:
            "arrow.clockwise"
        case .searching:
            "magnifyingglass"
        }
    }

    var titleKey: String {
        switch self {
        case .success:
            "common.overlay.success"
        case .error:
            "common.overlay.error"
        case .warning:
            "common.overlay.warning"
        case .info:
            "common.overlay.info"
        case .loading:
            "common.overlay.loading"
        case .searching:
            "common.overlay.searching"
        case .processing:
            "common.overlay.processing"
        }
    }

    var usesIndeterminateProgress: Bool {
        switch self {
        case .loading, .searching, .processing:
            true
        case .success, .error, .warning, .info:
            false
        }
    }
}

enum OverlayText: Equatable, Sendable {
    case key(String)
    case verbatim(String)
}

struct OverlayMessage: Identifiable, Equatable, Sendable {
    let id: UUID
    let sessionID: UUID?
    let scope: OverlayScope
    let kind: OverlayKind
    let style: OverlayStyle
    let text: OverlayText
    let iconName: String
    let progress: Double?
    let autoDismissAfter: TimeInterval?
    let tapToDismiss: Bool
    let dimBackground: Bool

    init(
        id: UUID = UUID(),
        sessionID: UUID? = nil,
        scope: OverlayScope = .root,
        kind: OverlayKind,
        style: OverlayStyle,
        text: OverlayText,
        iconName: String,
        progress: Double? = nil,
        autoDismissAfter: TimeInterval? = nil,
        tapToDismiss: Bool = false,
        dimBackground: Bool = false
    ) {
        self.id = id
        self.sessionID = sessionID
        self.scope = scope
        self.kind = kind
        self.style = style
        self.text = text
        self.iconName = iconName
        self.progress = progress.map { min(max($0, 0), 1) }
        self.autoDismissAfter = autoDismissAfter
        self.tapToDismiss = tapToDismiss
        self.dimBackground = dimBackground
    }
}

@MainActor
@Observable
final class OverlayStore {
    private enum Defaults {
        static let bannerAutoDismissAfter: TimeInterval = 1.8
    }

    var currentBanner: OverlayMessage?
    var currentHUD: OverlayMessage?

    private var bannerDismissTask: Task<Void, Never>?

    func makeHUDSession(scope: OverlayScope = .root) -> HUDSession {
        HUDSession(store: self, scope: scope)
    }

    func showBanner(
        style: OverlayStyle,
        text: OverlayText,
        iconName: String? = nil,
        autoDismissAfter: TimeInterval? = Defaults.bannerAutoDismissAfter,
        tapToDismiss: Bool = true,
        scope: OverlayScope = .root
    ) {
        let message = OverlayMessage(
            scope: scope,
            kind: .banner,
            style: style,
            text: text,
            iconName: iconName ?? style.defaultIconName,
            autoDismissAfter: autoDismissAfter,
            tapToDismiss: tapToDismiss
        )

        presentBanner(message)
    }

    func showBannerSuccess(_ text: OverlayText, scope: OverlayScope = .root) {
        showBanner(style: .success, text: text, scope: scope)
    }

    func showBannerError(_ text: OverlayText, scope: OverlayScope = .root) {
        showBanner(style: .error, text: text, scope: scope)
    }

    func showBannerWarning(_ text: OverlayText, scope: OverlayScope = .root) {
        showBanner(style: .warning, text: text, scope: scope)
    }

    func showBannerInfo(_ text: OverlayText, scope: OverlayScope = .root) {
        showBanner(style: .info, text: text, scope: scope)
    }

    @discardableResult
    func showHUD(
        style: OverlayStyle,
        text: OverlayText,
        iconName: String? = nil,
        progress: Double? = nil,
        dimBackground: Bool = false,
        tapToDismiss: Bool = false,
        scope: OverlayScope = .root
    ) -> UUID {
        let messageID = UUID()
        presentHUD(
            id: messageID,
            sessionID: nil,
            scope: scope,
            style: style,
            text: text,
            iconName: iconName,
            progress: progress,
            dimBackground: dimBackground,
            tapToDismiss: tapToDismiss
        )
        return messageID
    }

    func updateHUD(
        text: OverlayText? = nil,
        progress: Double? = nil,
        style: OverlayStyle? = nil,
        iconName: String? = nil
    ) {
        guard let currentHUD, currentHUD.sessionID == nil else {
            return
        }

        updateCurrentHUD(
            currentHUD,
            text: text,
            progress: progress,
            style: style,
            iconName: iconName
        )
    }

    func hideBanner() {
        bannerDismissTask?.cancel()
        bannerDismissTask = nil
        withAnimation(.spring(response: 0.35, dampingFraction: 0.86)) {
            currentBanner = nil
        }
    }

    func hideBanner(scope: OverlayScope) {
        guard currentBanner?.scope == scope else {
            return
        }

        hideBanner()
    }

    func hideHUD() {
        dismissCurrentHUD()
    }

    func hideHUD(scope: OverlayScope) {
        guard currentHUD?.scope == scope else {
            return
        }

        dismissCurrentHUD()
    }

    func presentHUD(
        id: UUID,
        sessionID: UUID?,
        scope: OverlayScope,
        style: OverlayStyle,
        text: OverlayText,
        iconName: String? = nil,
        progress: Double? = nil,
        dimBackground: Bool = false,
        tapToDismiss: Bool = false
    ) {
        let message = OverlayMessage(
            id: id,
            sessionID: sessionID,
            scope: scope,
            kind: .hud,
            style: style,
            text: text,
            iconName: iconName ?? style.defaultIconName,
            progress: progress,
            tapToDismiss: tapToDismiss,
            dimBackground: dimBackground
        )

        withAnimation(.easeInOut(duration: 0.18)) {
            currentHUD = message
        }
    }

    func updateHUD(
        sessionID: UUID,
        hudID: UUID,
        text: OverlayText? = nil,
        progress: Double? = nil,
        style: OverlayStyle? = nil,
        iconName: String? = nil
    ) {
        guard let currentHUD,
              currentHUD.id == hudID,
              currentHUD.sessionID == sessionID else {
            return
        }

        updateCurrentHUD(
            currentHUD,
            text: text,
            progress: progress,
            style: style,
            iconName: iconName
        )
    }

    func hideHUD(sessionID: UUID, hudID: UUID) {
        guard let currentHUD,
              currentHUD.id == hudID,
              currentHUD.sessionID == sessionID else {
            return
        }

        dismissCurrentHUD()
    }

    func invalidateHUDSession(_ sessionID: UUID) {
        guard currentHUD?.sessionID == sessionID else {
            return
        }

        dismissCurrentHUD()
    }

    private func presentBanner(_ message: OverlayMessage) {
        bannerDismissTask?.cancel()
        withAnimation(.spring(response: 0.35, dampingFraction: 0.86)) {
            currentBanner = message
        }
        scheduleBannerDismissIfNeeded(for: message)
    }

    private func updateCurrentHUD(
        _ currentHUD: OverlayMessage,
        text: OverlayText? = nil,
        progress: Double? = nil,
        style: OverlayStyle? = nil,
        iconName: String? = nil
    ) {
        let resolvedStyle = style ?? currentHUD.style

        self.currentHUD = OverlayMessage(
            id: currentHUD.id,
            sessionID: currentHUD.sessionID,
            scope: currentHUD.scope,
            kind: .hud,
            style: resolvedStyle,
            text: text ?? currentHUD.text,
            iconName: iconName ?? currentHUD.iconName,
            progress: progress ?? currentHUD.progress,
            tapToDismiss: currentHUD.tapToDismiss,
            dimBackground: currentHUD.dimBackground
        )
    }

    private func dismissCurrentHUD() {
        withAnimation(.easeInOut(duration: 0.18)) {
            currentHUD = nil
        }
    }

    private func scheduleBannerDismissIfNeeded(for message: OverlayMessage) {
        guard let autoDismissAfter = message.autoDismissAfter else {
            return
        }

        bannerDismissTask = Task { @MainActor in
            let targetID = message.id
            try? await Task.sleep(nanoseconds: UInt64(autoDismissAfter * 1_000_000_000))
            guard !Task.isCancelled, self.currentBanner?.id == targetID else {
                return
            }
            self.hideBanner()
        }
    }
}
