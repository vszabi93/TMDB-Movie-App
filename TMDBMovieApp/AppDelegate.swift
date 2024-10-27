import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var coordinator: AppCoordinatorInput?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        start()
    }

    private func start() -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        coordinator = AppCoordinator(window: window)
        coordinator?.start()
        return true
    }
}
