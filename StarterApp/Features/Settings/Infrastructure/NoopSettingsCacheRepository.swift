struct NoopSettingsCacheRepository: SettingsCacheRepositoryProtocol {
    func loadCacheSummary() async -> SettingsCacheSummary {
        .zero
    }

    func clearCache() async throws -> SettingsCacheClearResult {
        SettingsCacheClearResult(freedBytes: 0)
    }
}
