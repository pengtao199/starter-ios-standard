import SwiftUI

struct LegalDocumentView: View {
    let store: LegalDocumentStore

    var body: some View {
        LegalDocumentWebView(url: store.url)
            .background(Color(uiColor: .systemBackground))
            .ignoresSafeArea()
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
    }
}
