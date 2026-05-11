import Foundation

@MainActor
final class SubscriptionStateRepository: SubscriptionStateRepositoryProtocol {
    private let userDefaults: UserDefaults
    private let key = "starter.subscription.entitlement"
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func loadEntitlement() -> SubscriptionEntitlement? {
        guard let data = userDefaults.data(forKey: key) else {
            return nil
        }

        return try? decoder.decode(SubscriptionEntitlement.self, from: data)
    }

    func saveEntitlement(_ entitlement: SubscriptionEntitlement) {
        guard let data = try? encoder.encode(entitlement) else {
            return
        }

        userDefaults.set(data, forKey: key)
    }

    func clearEntitlement() {
        userDefaults.removeObject(forKey: key)
    }
}
