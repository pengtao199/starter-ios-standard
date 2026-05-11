struct LoadAppPreferencesUseCase {
    private let appPreferencesRepository: AppPreferencesRepositoryProtocol

    init(appPreferencesRepository: AppPreferencesRepositoryProtocol) {
        self.appPreferencesRepository = appPreferencesRepository
    }

    @MainActor
    func execute() -> AppPreferences {
        appPreferencesRepository.loadPreferences()
    }
}
