protocol MovieDetailsInteractorInput: AnyObject {
    func getMovieDetails(movieId: Int, completion: @escaping (Result<MovieDetailResponse, MovieError>) -> Void)
}

final class MovieDetailsInteractor {
    // MARK: - Services

    private let movieService: MovieServiceInput

    // MARK: - Initialization

    init(movieService: MovieServiceInput) {
        self.movieService = movieService
    }
}

extension MovieDetailsInteractor: MovieDetailsInteractorInput {
    func getMovieDetails(movieId: Int, completion: @escaping (Result<MovieDetailResponse, MovieError>) -> Void) {
        movieService.fetchMovieDetail(movieId: movieId) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(.getMoviesFailed))
            }
        }
    }
}
