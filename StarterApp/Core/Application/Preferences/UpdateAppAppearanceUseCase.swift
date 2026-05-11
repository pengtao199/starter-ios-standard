struct UpdateAppAppearanceUseCase {
    private let appPreferencesRepository: AppPreferencesRepositoryProtocol

    init(appPreferencesRepository: AppPreferencesRepositoryProtocol) {
        self.appPreferencesRepository = appPreferencesRepository
    }

    @MainActor
    func execute(_ appearance: AppAppearance) {
        appPreferencesRepository.updateAppearance(appearance)
    }
}
