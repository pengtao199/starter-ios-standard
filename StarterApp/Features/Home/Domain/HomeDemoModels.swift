import Foundation

struct HomeDemoItem: Identifiable, Equatable, Sendable {
    let id: UUID
    let titleKey: String
    let descriptionKey: String

    init(
        id: UUID = UUID(),
        titleKey: String,
        descriptionKey: String
    ) {
        self.id = id
        self.titleKey = titleKey
        self.descriptionKey = descriptionKey
    }
}
