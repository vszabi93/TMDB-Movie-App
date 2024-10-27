// sourcery: AutoMockable
protocol MovieListInteractorInput: AnyObject {
    func getPopularMovies(page: Int, completion: @escaping (Result<MovieResponse, MovieError>) -> Void)
    func getSearchResult(query: String, completion: @escaping (Result<MovieResponse, MovieError>) -> Void)
}

final class MovieListInteractor {
    // MARK: - Services

    private let movieService: MovieServiceInput

    // MARK: - Initialization

    init(movieService: MovieServiceInput) {
        self.movieService = movieService
    }
}

extension MovieListInteractor: MovieListInteractorInput {
    func getPopularMovies(page: Int, completion: @escaping (Result<MovieResponse, MovieError>) -> Void) {
        movieService.fetchPopularMovies(page: page) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(.getMoviesFailed))
            }
        }
    }
    func getSearchResult(query: String, completion: @escaping (Result<MovieResponse, MovieError>) -> Void) {
        movieService.fetchSearchResult(query: query) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(.getMoviesFailed))
            }
        }
    }
}
