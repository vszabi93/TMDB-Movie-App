import Resolver

extension Resolver {
    static func registerInteractorLayer() {
        register(MovieListInteractorInput.self) { MovieListInteractor(movieService: resolve()) }
        register(MovieDetailsInteractorInput.self) { MovieDetailsInteractor(movieService: resolve()) }
    }
}
