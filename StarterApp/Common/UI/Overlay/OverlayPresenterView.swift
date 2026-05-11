import SwiftUI

struct OverlayPresenterView: View {
    let model: OverlayPresenterModel
    let scope: OverlayScope
    let onDismissBanner: @MainActor () -> Void
    let onDismissHUD: @MainActor () -> Void

    var body: some View {
        ZStack {
            if let hud = filteredHUD {
                HUDOverlayContainerView(
                    message: hud,
                    onDismiss: onDismissHUD
                )
                .transition(.opacity.combined(with: .scale(scale: 0.96)))
                .zIndex(1)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(alignment: .top) {
            if let banner = filteredBanner {
                BannerOverlayView(
                    message: banner,
                    onDismiss: onDismissBanner
                )
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.86), value: model.banner?.id)
        .animation(.easeInOut(duration: 0.18), value: model.hud?.id)
    }

    private var filteredBanner: OverlayPresenterModel.Banner? {
        guard model.banner?.scope == scope else {
            return nil
        }

        return model.banner
    }

    private var filteredHUD: OverlayPresenterModel.HUD? {
        guard model.hud?.scope == scope else {
            return nil
        }

        return model.hud
    }
}

private struct BannerOverlayView: View {
    private enum Layout {
        static let maxBannerWidth: CGFloat = 420
    }

    let message: OverlayPresenterModel.Banner
    let onDismiss: @MainActor () -> Void

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: message.iconName)
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.primary)
                .frame(width: 20, height: 20)

            OverlayTextView(text: message.text)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(.primary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.88)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .bannerSurface()
        .frame(maxWidth: Layout.maxBannerWidth)
        .frame(maxWidth: .infinity)
        .onTapGesture {
            guard message.tapToDismiss else {
                return
            }

            onDismiss()
        }
        .padding(.horizontal, 16)
        .safeAreaPadding(.top, 8)
    }
}

private struct HUDOverlayContainerView: View {
    let message: OverlayPresenterModel.HUD
    let onDismiss: @MainActor () -> Void

    var body: some View {
        ZStack {
            if message.dimBackground {
                Color.black.opacity(0.18)
                    .ignoresSafeArea()
                    .onTapGesture {
                        guard message.tapToDismiss else {
                            return
                        }

                        onDismiss()
                    }
            }

            OverlayHUDCardView(
                iconName: message.iconName,
                title: message.title,
                message: message.message,
                progress: message.progress,
                usesIndeterminateProgress: message.usesIndeterminateProgress
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
