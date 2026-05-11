struct ClearSettingsCacheUseCase {
    private let settingsCacheRepository: SettingsCacheRepositoryProtocol

    init(settingsCacheRepository: SettingsCacheRepositoryProtocol) {
        self.settingsCacheRepository = settingsCacheRepository
    }

    func execute() async throws -> SettingsCacheClearResult {
        try await settingsCacheRepository.clearCache()
    }
}
