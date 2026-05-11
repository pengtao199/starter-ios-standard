struct LoadSettingsCacheSummaryUseCase {
    private let settingsCacheRepository: SettingsCacheRepositoryProtocol

    init(settingsCacheRepository: SettingsCacheRepositoryProtocol) {
        self.settingsCacheRepository = settingsCacheRepository
    }

    func execute() async -> SettingsCacheSummary {
        await settingsCacheRepository.loadCacheSummary()
    }
}
