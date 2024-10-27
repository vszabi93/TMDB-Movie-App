protocol MovieListPresenterInput: AnyObject {
    var view: MovieListView? { get set }
    var movies: [MovieResult]? { get set }
    func viewDidLoad()
    func didTapCell(at index: Int)
    func fetchMoreMovies()
}

final class MovieListPresenter {
    private let coordinator: MovieCoordinatorInput
    private let interactor: MovieListInteractorInput
    weak var view: MovieListView?

    var movies: [MovieResult]?
    private var currentPage: Int = 1
    private var totalPages: Int = .zero

    init(coordinator: MovieCoordinatorInput, interactor: MovieListInteractorInput) {
        self.coordinator = coordinator
        self.interactor = interactor
    }

    private func getMovies() {
        interactor.getPopularMovies(page: currentPage) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let movies):
                if let totalPages = movies.totalPages {
                    self.totalPages = totalPages
                }
                self.currentPage += 1
                guard self.movies != nil else {
                    self.movies = movies.results
                    self.view?.updateTableView()
                    return
                }
                if let movies = movies.results {
                    self.movies?.append(contentsOf: movies)

                }
                self.view?.updateTableView()
            case .failure(let error):
                // TODO handle error
                print(error.localizedDescription)
            }
        }
    }
}

extension MovieListPresenter: MovieListPresenterInput {
    func viewDidLoad() {
        getMovies()
    }

    func didTapCell(at index: Int) {
        guard let movieId = movies?[index].id else { return }
        coordinator.showMovieDetails(with: movieId)
    }

    func fetchMoreMovies() {
        guard currentPage < totalPages else { return }
        getMovies()
    }
}
