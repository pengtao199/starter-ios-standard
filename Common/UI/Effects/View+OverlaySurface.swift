import SwiftUI

extension View {
    @ViewBuilder
    func bannerSurface(isInteractive: Bool = false) -> some View {
        if #available(iOS 26.0, *) {
            self
                .glassEffect(
                    .regular
                        .tint(.white.opacity(0.10))
                        .interactive(isInteractive),
                    in: Capsule()
                )
                .shadow(color: .black.opacity(0.12), radius: 14, y: 7)
        } else {
            background(.ultraThinMaterial, in: Capsule())
                .overlay {
                    Capsule()
                        .stroke(Color.primary.opacity(0.08), lineWidth: 1)
                }
                .shadow(color: .black.opacity(0.10), radius: 12, y: 6)
        }
    }

    @ViewBuilder
    func hudSurface(cornerRadius: CGFloat) -> some View {
        if #available(iOS 26.0, *) {
            self
                .glassEffect(
                    .regular.tint(.white.opacity(0.08)),
                    in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                )
                .shadow(color: .black.opacity(0.16), radius: 20, y: 9)
        } else {
            background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .stroke(Color.primary.opacity(0.08), lineWidth: 1)
                }
                .shadow(color: .black.opacity(0.14), radius: 18, y: 8)
        }
    }
}
