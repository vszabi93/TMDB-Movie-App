import Resolver

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        registerInteractorLayer()
        registerServiceLayer()
        registerNetworkModule()
    }
}
