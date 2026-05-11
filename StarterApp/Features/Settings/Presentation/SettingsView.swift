import MessageUI
import SwiftUI
import UIKit

struct SettingsView: View {
    @Bindable var store: SettingsStore
    let subscriptionStore: SubscriptionStore
    @Environment(\.openURL) private var openURL

    var body: some View {
        List {
            Section {
                SettingsActionRow(item: store.content.subscriptionItem, action: store.presentSubscription)
            }

            Section("settings.section.general") {
                Picker(
                    selection: Binding(
                        get: { store.selectedAppearance },
                        set: { store.setAppearance($0) }
                    )
                ) {
                    ForEach(store.content.appearanceOptions) { option in
                        Text(LocalizedStringKey(option.titleKey))
                            .tag(option.value)
                    }
                } label: {
                    Label(LocalizedStringKey("settings.appearance"), systemImage: "circle.lefthalf.filled")
                }
                .pickerStyle(.menu)

                Picker(
                    selection: Binding(
                        get: { store.selectedLanguage },
                        set: { store.setLanguage($0) }
                    )
                ) {
                    ForEach(store.content.languageOptions) { option in
                        Text(LocalizedStringKey(option.titleKey))
                            .tag(option.value)
                    }
                } label: {
                    Label(LocalizedStringKey("settings.language"), systemImage: "globe")
                }
                .pickerStyle(.menu)

                SettingsActionRow(
                    item: store.content.clearCacheItem,
                    trailingText: store.cacheSummaryText,
                    showsProgress: store.isClearingCache
                ) {
                    Task {
                        await store.clearCache()
                    }
                }
            }

            Section("settings.section.support") {
                SettingsActionRow(item: store.content.rateItem, action: store.requestReview)
                SettingsActionRow(item: store.content.shareItem, action: store.prepareShare)
                SettingsActionRow(item: store.content.feedbackItem, action: store.openFeedback)
            }

            Section("settings.section.legal") {
                ForEach(store.content.legalItems) { item in
                    Button {
                        store.presentLegalDocument(item.type)
                    } label: {
                        Label(LocalizedStringKey(item.titleKey), systemImage: item.systemImage)
                    }
                    .buttonStyle(.plain)
                }
            }

            Section("settings.section.about") {
                LabeledContent("settings.app.name", value: store.content.appName)
                LabeledContent("settings.app.version", value: store.content.appVersionText)
            }

            Section {
                SettingsActionRow(
                    item: store.content.restorePurchaseItem,
                    showsProgress: store.isRestoringPurchases
                ) {
                    Task {
                        await store.restorePurchases()
                    }
                }
            }
        }
        .tint(.primary)
        .navigationTitle(LocalizedStringKey(store.content.titleKey))
        .navigationBarTitleDisplayMode(.large)
        .listStyle(.insetGrouped)
        .task {
            await store.loadCacheSummaryIfNeeded()
        }
        .sheet(
            item: Binding(
                get: { store.presentedSheet },
                set: { value in
                    if value == nil {
                        store.dismissPresentedSheet()
                    }
                }
            ),
            content: presentedSheetView
        )
        .fullScreenCover(
            item: Binding(
                get: { store.presentedFullScreenCover },
                set: { value in
                    if value == nil {
                        store.dismissPresentedFullScreenCover()
                    }
                }
            ),
            content: presentedFullScreenView
        )
        .onChange(of: store.pendingExternalURL) { _, url in
            guard let resolvedURL = store.consumePendingExternalURL() ?? url else {
                return
            }

            openURL(resolvedURL)
        }
    }
}

private struct SettingsActionRow: View {
    let item: SettingsRowItem
    let trailingText: String?
    let showsProgress: Bool
    let action: () -> Void

    init(
        item: SettingsRowItem,
        trailingText: String? = nil,
        showsProgress: Bool = false,
        action: @escaping () -> Void
    ) {
        self.item = item
        self.trailingText = trailingText
        self.showsProgress = showsProgress
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Label(LocalizedStringKey(item.titleKey), systemImage: item.systemImage)

                Spacer(minLength: 12)

                if showsProgress {
                    ProgressView()
                        .controlSize(.small)
                } else if let trailingText {
                    Text(verbatim: trailingText)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .buttonStyle(.plain)
        .disabled(showsProgress)
    }
}

private struct SettingsShareSheet: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: [url], applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

private struct SettingsFeedbackMailComposer: UIViewControllerRepresentable {
    let recipient: String
    let subject: String
    let onFinish: @MainActor () -> Void

    final class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        let onFinish: @MainActor () -> Void

        init(onFinish: @escaping @MainActor () -> Void) {
            self.onFinish = onFinish
        }

        func mailComposeController(
            _ controller: MFMailComposeViewController,
            didFinishWith result: MFMailComposeResult,
            error: Error?
        ) {
            let finish = onFinish
            MainActor.assumeIsolated {
                controller.dismiss(animated: true)
                finish()
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(onFinish: onFinish)
    }

    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let controller = MFMailComposeViewController()
        controller.setToRecipients([recipient])
        controller.setSubject(subject)
        controller.mailComposeDelegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}
}

private extension SettingsView {
    @ViewBuilder
    func presentedSheetView(for destination: SettingsSheetDestination) -> some View {
        switch destination {
        case let .share(url):
            SettingsShareSheet(url: url)
        case let .feedbackComposer(recipient, subject):
            SettingsFeedbackMailComposer(
                recipient: recipient,
                subject: subject,
                onFinish: { store.dismissPresentedSheet() }
            )
        case let .legalDocument(type):
            LegalDocumentView(store: store.legalDocumentStore(for: type))
        }
    }

    @ViewBuilder
    func presentedFullScreenView(for destination: SettingsFullScreenDestination) -> some View {
        switch destination {
        case .subscription:
            SubscriptionView(
                store: subscriptionStore,
                onClose: { store.dismissPresentedFullScreenCover() }
            )
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView(
            store: AppContainer().appEnvironment.settingsStore,
            subscriptionStore: AppContainer().appEnvironment.subscriptionStore
        )
    }
}
