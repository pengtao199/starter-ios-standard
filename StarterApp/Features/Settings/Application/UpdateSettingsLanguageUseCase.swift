struct UpdateSettingsLanguageUseCase {
    private let updateAppLanguageUseCase: UpdateAppLanguageUseCase

    init(updateAppLanguageUseCase: UpdateAppLanguageUseCase) {
        self.updateAppLanguageUseCase = updateAppLanguageUseCase
    }

    @MainActor
    func execute(_ language: AppLanguage) {
        updateAppLanguageUseCase.execute(language)
    }
}
