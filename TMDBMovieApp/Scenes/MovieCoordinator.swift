import Resolver
import UIKit

// sourcery: AutoMockable
protocol MovieCoordinatorInput: AnyObject {
    func start()

    func showMovieList()
    func showMovieDetails(with id: Int)
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
        let presenter = MovieListPresenter(coordinator: self, interactor: Resolver.resolve())
        let viewController = MovieListViewController(presenter: presenter)
        presenter.view = viewController
        navigationController?.pushViewController(viewController, animated: true)
    }

    func showMovieDetails(with id: Int) {
        let presenter = MovieDetailsPresenter(coordinator: self, interactor: Resolver.resolve(), movieId: id)
        let viewController = MovieDetailsViewController(presenter: presenter)
        presenter.view = viewController
        navigationController?.pushViewController(viewController, animated: true)
    }
}
