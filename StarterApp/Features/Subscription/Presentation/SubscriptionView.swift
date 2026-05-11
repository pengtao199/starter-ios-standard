import SwiftUI

struct SubscriptionView: View {
    let store: SubscriptionStore
    let onClose: @MainActor () -> Void
    @Environment(\.locale) private var locale

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    headerSection
                    featureSection
                    planSection
                    footerSection
                }
                .padding(LayoutToken.pageInset)
            }
            .background(Color(uiColor: .systemGroupedBackground))
            .navigationTitle("subscription.title")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("common.action.close", action: onClose)
                }
            }
        }
        .task(id: locale.identifier) {
            await store.handleAppear(locale: locale)
        }
        .alert(
            "",
            isPresented: Binding(
                get: { store.alertMessageKey != nil },
                set: { value in
                    if value == false {
                        store.dismissAlert()
                    }
                }
            ),
            actions: {
                Button("common.action.close", role: .cancel) {
                    store.dismissAlert()
                }
            },
            message: {
                if let alertMessageKey = store.alertMessageKey {
                    Text(LocalizedStringKey(alertMessageKey))
                }
            }
        )
        .sheet(
            isPresented: Binding(
                get: { store.presentedLegalDocument != nil },
                set: { value in
                    if value == false {
                        store.dismissPresentedLegalDocument()
                    }
                }
            )
        ) {
            if let type = store.presentedLegalDocument {
                LegalDocumentView(store: store.legalDocumentStore(for: type))
            }
        }
    }
}

private extension SubscriptionView {
    var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(verbatim: store.content.title)
                .font(.largeTitle.bold())

            Text(LocalizedStringKey(store.content.subtitleKey))
                .font(.headline)
                .foregroundStyle(.secondary)

            if let activeBadgeKey = store.content.activeBadgeKey {
                Label(LocalizedStringKey(activeBadgeKey), systemImage: "checkmark.seal.fill")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.green)
            }
        }
    }

    var featureSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(store.content.featureItems) { item in
                Label {
                    Text(LocalizedStringKey(item.titleKey))
                } icon: {
                    Image(systemName: item.iconName)
                        .foregroundStyle(Color.accentColor)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(LayoutToken.cardPadding)
        .background(
            RoundedRectangle(cornerRadius: LayoutToken.cardCornerRadius, style: .continuous)
                .fill(Color(uiColor: .secondarySystemGroupedBackground))
        )
    }

    @ViewBuilder
    var planSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("subscription.plan.section")
                .font(.headline)

            if store.isLoadingPlans {
                ProgressView("subscription.plan.loading")
            } else if let planLoadErrorKey = store.planLoadErrorKey {
                ContentUnavailableView {
                    Label(LocalizedStringKey(planLoadErrorKey), systemImage: "tray")
                } description: {
                    Text("subscription.plan.placeholder")
                }
            } else {
                ForEach(store.planItems) { item in
                    Button {
                        store.selectPlan(productID: item.productID)
                    } label: {
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(LocalizedStringKey(item.titleKey ?? "subscription.plan.custom"))
                                    .font(.headline)

                                Spacer()

                                if item.productID == store.selectedProductID {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(Color.accentColor)
                                }
                            }

                            Text(verbatim: item.displayPrice)
                                .font(.title3.weight(.semibold))

                            if let equivalentWeeklyPrice = item.equivalentWeeklyPrice {
                                Text(verbatim: equivalentWeeklyPrice)
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(LayoutToken.cardPadding)
                        .background(
                            RoundedRectangle(cornerRadius: LayoutToken.cardCornerRadius, style: .continuous)
                                .fill(
                                    item.productID == store.selectedProductID
                                        ? Color.accentColor.opacity(0.12)
                                        : Color(uiColor: .secondarySystemGroupedBackground)
                                )
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    var footerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button {
                Task {
                    await store.purchaseSelectedPlan()
                }
            } label: {
                Text(
                    LocalizedStringKey(
                        store.content.isSubscriptionActive
                            ? "subscription.badge.active"
                            : "subscription.action.subscribe"
                    )
                )
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
            }
            .buttonStyle(.borderedProminent)
            .disabled(store.isPrimaryActionDisabled)

            Button {
                Task {
                    await store.restorePurchases()
                }
            } label: {
                Text("subscription.action.restore")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .disabled(store.isRestoringPurchases)

            HStack {
                Button("common.legal.terms") {
                    store.presentLegalDocument(.terms)
                }
                .buttonStyle(.plain)

                Spacer()

                Button("common.legal.privacy") {
                    store.presentLegalDocument(.privacy)
                }
                .buttonStyle(.plain)
            }
            .font(.footnote)
            .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    SubscriptionView(
        store: AppContainer().appEnvironment.subscriptionStore,
        onClose: {}
    )
}
