protocol SettingsCacheRepositoryProtocol: Sendable {
    func loadCacheSummary() async -> SettingsCacheSummary
    func clearCache() async throws -> SettingsCacheClearResult
}
