protocol MovieListPresenterInput: AnyObject {
    var view: MovieListView? { get set }
    var movies: [MovieResult]? { get }
    func viewDidLoad()
    func didTapCell(at index: Int)
    func fetchMoreMovies()
    func searchMovies(text: String)
}

final class MovieListPresenter {
    private let coordinator: MovieCoordinatorInput
    private let interactor: MovieListInteractorInput
    weak var view: MovieListView?

    var movies: [MovieResult]? {
        if searchText.isEmpty {
            return popularMovies
        } else {
            return searchMovies
        }
    }
    private var currentPage: Int = 1
    private var totalPages: Int = .zero

    private var popularMovies: [MovieResult]?
    private var searchMovies: [MovieResult]?
    private var searchCurrentPage: Int = 1
    private var searchTotalPages: Int = .zero
    private var searchText: String = "" {
        didSet {
            searchMovies = nil
            searchCurrentPage = 1
            searchTotalPages = .zero
        }
    }

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
                    self.popularMovies = movies.results
                    self.view?.updateTableView()
                    return
                }
                if let movies = movies.results {
                    self.popularMovies?.append(contentsOf: movies)

                }
                self.view?.updateTableView()
            case .failure(let error):
                print(error.localizedDescription)
                self.handleError(error)
            }
        }
    }

    private func getSearchMovies(text: String) {
        interactor.getSearchResult(query: text) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let movies):
                if let totalPages = movies.totalPages {
                    self.searchTotalPages = totalPages
                }
                self.searchCurrentPage += 1
                guard self.movies != nil else {
                    self.searchMovies = movies.results
                    self.view?.updateTableView()
                    return
                }
                if let movies = movies.results {
                    self.searchMovies?.append(contentsOf: movies)

                }
                self.view?.updateTableView()
            case .failure(let error):
                print(error.localizedDescription)
                self.handleError(error)

            }
        }
    }

    private func fetchMorePopularMovies() {
        guard currentPage < totalPages else { return }
        getMovies()
    }

    private func fetchMoreSearchMovies() {
        guard searchCurrentPage < searchTotalPages else { return }
        getSearchMovies(text: searchText)
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
        if searchText.isEmpty {
            fetchMorePopularMovies()
        } else {
            fetchMoreSearchMovies()
        }
    }

    func searchMovies(text: String) {
        guard !text.isEmpty else {
            searchText = ""
            view?.updateTableView()
            return
        }
        guard searchText != text else { return }
        searchText = text

        getSearchMovies(text: text)
    }
}

// MARK: - MoviesErrorHandleable

extension MovieListPresenter: MoviesErrorHandleable {}
