protocol MovieListPresenterInput: AnyObject {
    var view: MovieListView? { get set }
    var movies: [MovieResult]? { get }
    func viewDidLoad()
    func changePreferedMovies()
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
            return needPopularMovies ? popularMovies : topRatedMovies
        } else {
            return searchMovies
        }
    }

    private var needPopularMovies: Bool = true

    private var requeredAvarageRate: Double = 8

    private var topRatedMovies: [MovieResult]?
    private var currentTopRatedPage: Int = 1
    private var totalTopRatedPages: Int = .zero

    private var popularMovies: [MovieResult]?
    private var currentPopularPage: Int = 1
    private var totalPopularPages: Int = .zero

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
        interactor.getPopularMovies(page: currentPopularPage) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let movies):
                if let totalPages = movies.totalPages {
                    self.totalPopularPages = totalPages
                }
                self.currentPopularPage += 1
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

    private func getTopRatedMovies() {
        interactor.getTopRatedMovies(page: currentTopRatedPage) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let movies):
                if let totalPages = movies.totalPages {
                    self.totalTopRatedPages = totalPages
                }
                self.currentTopRatedPage += 1
                guard self.movies != nil else {
                    self.topRatedMovies = movies.results?.filter({$0.voteAverage ?? .zero > self.requeredAvarageRate})
                    self.view?.updateTableView()
                    return
                }
                if let movies = movies.results {
                    self.topRatedMovies?.append(contentsOf: movies)

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
        guard currentPopularPage < totalPopularPages else { return }
        getMovies()
    }

    private func fetchMoreTopRatedMovies() {
        guard currentTopRatedPage < totalTopRatedPages else { return }
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

    func changePreferedMovies() {
        needPopularMovies = !needPopularMovies
        if needPopularMovies && popularMovies == nil {
            getMovies()
        } else if !needPopularMovies && topRatedMovies == nil {
            getTopRatedMovies()
        }
        view?.updateTableView()
    }

    func didTapCell(at index: Int) {
        guard let movieId = movies?[index].id else { return }
        coordinator.showMovieDetails(with: movieId)
    }

    func fetchMoreMovies() {
        switch (searchText, needPopularMovies) {
        case (let searchText, needPopularMovies) where searchText.isEmpty && needPopularMovies:
            fetchMorePopularMovies()
        case (let searchText, needPopularMovies) where searchText.isEmpty && !needPopularMovies:
            fetchMoreTopRatedMovies()
        default:
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
