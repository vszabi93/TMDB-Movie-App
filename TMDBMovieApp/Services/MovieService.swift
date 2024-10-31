protocol MovieServiceInput {
    func fetchPopularMovies(page: Int, completion: @escaping (Result<MovieResponse, NetworkError>) -> Void)
    func fetchTopRatedMovies(page: Int, completion: @escaping (Result<MovieResponse, NetworkError>) -> Void)
    func fetchMovieDetail(movieId: Int, completion: @escaping (Result<MovieDetailResponse, NetworkError>) -> Void)
    func fetchSearchResult(query: String, completion: @escaping (Result<MovieResponse, NetworkError>) -> Void)
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
    func fetchPopularMovies(page: Int, completion: @escaping (Result<MovieResponse, NetworkError>) -> Void) {
        networkModule.fetchPopularMovies(page: page, completion: completion)
    }

    func fetchTopRatedMovies(page: Int, completion: @escaping (Result<MovieResponse, NetworkError>) -> Void) {
        networkModule.fetchTopRatedMovies(page: page, completion: completion)
    }

    func fetchMovieDetail(movieId: Int, completion: @escaping (Result<MovieDetailResponse, NetworkError>) -> Void) {
        networkModule.fetchMovieDetail(movieId: movieId, completion: completion)
    }

    func fetchSearchResult(query: String, completion: @escaping (Result<MovieResponse, NetworkError>) -> Void) {
        networkModule.fetchSearchResult(query: query, completion: completion)
    }
}
