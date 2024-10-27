import Resolver

extension Resolver {
    static func registerInteractorLayer() {
        register(MovieListInteractorInput.self) { MovieListInteractor(movieService: resolve()) }
    }
}
