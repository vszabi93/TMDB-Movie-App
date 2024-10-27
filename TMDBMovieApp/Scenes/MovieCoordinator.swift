import UIKit

protocol MovieCoordinatorInput: AnyObject {
    func start()

    func showMovieList()
    func showMovieDetails(with id: String)
}

final class MovieCoordinator {

    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController? = nil) {
        self.navigationController = navigationController
    }

    func start() {
        showMovieList()
    }
}

extension MovieCoordinator: MovieCoordinatorInput {
    func showMovieList() {
        let viewControler = MovieListViewController()
        navigationController?.pushViewController(viewControler, animated: true)
    }

    func showMovieDetails(with id: String) {}
}
