struct UpdateSettingsAppearanceUseCase {
    private let updateAppAppearanceUseCase: UpdateAppAppearanceUseCase

    init(updateAppAppearanceUseCase: UpdateAppAppearanceUseCase) {
        self.updateAppAppearanceUseCase = updateAppAppearanceUseCase
    }

    @MainActor
    func execute(_ appearance: AppAppearance) {
        updateAppAppearanceUseCase.execute(appearance)
    }
}
