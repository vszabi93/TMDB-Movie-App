import UIKit

protocol AppCoordinatorInput: AnyObject {
    func start()
}

final class AppCoordinator {
    private let window: UIWindow

    private let navigationController: UINavigationController = {
        let navigationController = UINavigationController()
        return navigationController
    }()

    init?(window: UIWindow?) {
        guard let window = window else { return nil }
        self.window = window
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}

extension AppCoordinator: AppCoordinatorInput {
    func start() {
        MovieCoordinator(navigationController: navigationController).start()
    }
}
