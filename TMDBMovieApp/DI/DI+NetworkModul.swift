import Resolver

extension Resolver {
    static func registerNetworkModule() {
        register(NetworModuleInput.self) { NetworModule() }
    }
}
