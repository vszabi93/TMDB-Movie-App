import Resolver

extension Resolver {
    static func registerServiceLayer() {
        register(MovieServiceInput.self) { MovieService(networkModule: resolve()) }
    }
}
