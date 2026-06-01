struct UpdateAppLanguageUseCase {
    private let appPreferencesRepository: AppPreferencesRepositoryProtocol

    init(appPreferencesRepository: AppPreferencesRepositoryProtocol) {
        self.appPreferencesRepository = appPreferencesRepository
    }

    @MainActor
    func execute(_ language: AppLanguage) {
        appPreferencesRepository.updateLanguage(language)
    }
}
