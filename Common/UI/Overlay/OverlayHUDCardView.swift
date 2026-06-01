import SwiftUI

struct OverlayHUDCardView: View {
    let iconName: String
    let title: OverlayPresenterModel.TextContent
    let message: OverlayPresenterModel.TextContent?
    let progress: Double?
    let usesIndeterminateProgress: Bool

    private let cornerRadius: CGFloat = 28
    private let indicatorHeight: CGFloat = 28
    private let progressWidth: CGFloat = 182
    private let cardWidth: CGFloat = 232

    var body: some View {
        VStack(spacing: 14) {
            indicatorView

            VStack(spacing: 4) {
                OverlayTextView(text: title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.primary)

                if let secondaryMessage, secondaryMessage != title {
                    OverlayTextView(text: secondaryMessage)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .lineLimit(3)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .padding(.horizontal, 26)
        .padding(.vertical, 18)
        .frame(maxWidth: cardWidth)
        .hudSurface(cornerRadius: cornerRadius)
    }

    private var secondaryMessage: OverlayPresenterModel.TextContent? {
        guard let message else {
            return nil
        }

        switch message {
        case let .verbatim(value) where value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty:
            return nil
        default:
            return message
        }
    }

    @ViewBuilder
    private var indicatorView: some View {
        if let progress {
            progressBar(progress)
        } else if usesIndeterminateProgress {
            ProgressView()
                .controlSize(.regular)
                .frame(height: indicatorHeight)
        } else {
            Image(systemName: iconName)
                .font(.system(size: 28, weight: .regular))
                .foregroundStyle(.primary)
                .frame(height: indicatorHeight)
        }
    }

    private func progressBar(_ progress: Double) -> some View {
        let clamped = min(max(progress, 0), 1)

        return ZStack(alignment: .leading) {
            Capsule()
                .fill(Color.primary.opacity(0.10))

            GeometryReader { proxy in
                Capsule()
                    .fill(Color.accentColor.opacity(0.85))
                    .frame(width: max(40, proxy.size.width * clamped))
            }

            Text(clamped.formatted(.percent.precision(.fractionLength(0))))
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(Color(uiColor: .systemBackground))
                .frame(maxWidth: .infinity)
        }
        .frame(width: progressWidth, height: indicatorHeight)
        .clipShape(Capsule())
    }
}

struct OverlayTextView: View {
    let text: OverlayPresenterModel.TextContent

    var body: some View {
        switch text {
        case let .key(key):
            Text(LocalizedStringKey(key))
        case let .verbatim(value):
            Text(verbatim: value)
        }
    }
}
