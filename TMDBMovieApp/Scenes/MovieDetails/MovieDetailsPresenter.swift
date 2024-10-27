protocol MovieDetailsPresenterInput: AnyObject {
    var view: MovieDetailsView? { get set }

    func viewDidLoad()
    func didTapBackButton()
}

final class MovieDetailsPresenter {
    private let coordinator: MovieCoordinatorInput
    private let interactor: MovieDetailsInteractorInput
    weak var view: MovieDetailsView?

    private let movieId: Int

    init(coordinator: MovieCoordinatorInput,
         interactor: MovieDetailsInteractorInput,
         movieId: Int) {
        self.coordinator = coordinator
        self.interactor = interactor
        self.movieId = movieId
    }
}

extension MovieDetailsPresenter: MovieDetailsPresenterInput {

    func viewDidLoad() {
        interactor.getMovieDetails(movieId: movieId) { [weak self] response in
            switch response {
            case .success(let details):
                self?.view?.updateDetails(with: details)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func didTapBackButton() {
        coordinator.showMovieList()
    }
}
