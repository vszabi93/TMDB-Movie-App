protocol MovieServiceInput {
    func fetchPopularMovies(page: Int, completion: @escaping (Result<MovieResponse, Error>) -> Void)
    func fetchMovieDetail(movieId: Int, completion: @escaping (Result<MovieDetailResponse, Error>) -> Void)
    func fetchSearchResult(query: String, completion: @escaping (Result<MovieResponse, Error>) -> Void)
}

final class MovieService {

    // MARK: - Private properties

    private let networkModule: NetworModuleInput

    // MARK: - Initialization

    init(networkModule: NetworModuleInput) {
        self.networkModule = networkModule
    }
}

extension MovieService: MovieServiceInput {
    func fetchPopularMovies(page: Int, completion: @escaping (Result<MovieResponse, Error>) -> Void) {
        networkModule.fetchPopularMovies(page: page, completion: completion)
    }

    func fetchMovieDetail(movieId: Int, completion: @escaping (Result<MovieDetailResponse, Error>) -> Void) {
        networkModule.fetchMovieDetail(movieId: movieId, completion: completion)
    }

    func fetchSearchResult(query: String, completion: @escaping (Result<MovieResponse, Error>) -> Void) {
        networkModule.fetchSearchResult(query: query, completion: completion)
    }
}
