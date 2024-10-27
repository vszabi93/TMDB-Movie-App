import Moya

protocol NetworModuleInput {
    var provider: MoyaProvider<API> { get }

    func fetchPopularMovies(page: Int, completion: @escaping (Result<MovieResponse, Error>) -> Void)
    func fetchMovieDetail(movieId: Int, completion: @escaping (Result<MovieDetailResponse, Error>) -> Void)
    func fetchSearchResult(query: String, completion: @escaping (Result<MovieResponse, Error>) -> Void)
}

class NetworModule: NetworModuleInput {
    var provider = MoyaProvider<API>(plugins: [NetworkLoggerPlugin()])

    func fetchPopularMovies(page: Int, completion: @escaping (Result<MovieResponse, Error>) -> Void) {
        request(target: .popular(page: page), completion: completion)
    }

    func fetchMovieDetail(movieId: Int, completion: @escaping (Result<MovieDetailResponse, Error>) -> Void) {
        request(target: .movie(movieId: movieId), completion: completion)
    }

    func fetchSearchResult(query: String, completion: @escaping (Result<MovieResponse, Error>) -> Void) {
        request(target: .search(query: query), completion: completion)
    }
}

private extension NetworModule {
    private func request<T: Decodable>(target: API, completion: @escaping (Result<T, Error>) -> Void) {
        provider.request(target) { result in
            switch result {
            case let .success(response):
                do {
                    let results = try JSONDecoder().decode(T.self, from: response.data)
                    completion(.success(results))
                } catch let error {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}

