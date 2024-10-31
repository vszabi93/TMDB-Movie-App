import Moya

enum API {
    case popular(page: Int)
    case topRated(page: Int)
    case movie(movieId: Int)
    case search(query: String)

    static let apiKey = "555dd34b51d2f5b7f9fdb39e04986933"

}

extension API: TargetType {
    var baseURL: URL {
        guard let url = URL(string: "https://api.themoviedb.org/3/") else { fatalError("There is no baseURl") }
        return url
    }

    var path: String {
        switch self {
        case .popular:
            return "movie/popular"
        case .topRated:
            return "movie/top_rated"
        case .movie(let movieId):
            return "movie/\(movieId)"
        case .search:
            return "search/movie"
        }
    }

    var method: Method {
        return .get
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case .popular(let page):
            return .requestParameters(parameters: ["api_key": API.apiKey, "page": page], encoding: URLEncoding.queryString)
        case .topRated(let page):
            return .requestParameters(parameters: ["api_key": API.apiKey, "page": page], encoding: URLEncoding.queryString)
        case .movie:
            return .requestParameters(parameters: ["api_key": API.apiKey], encoding: URLEncoding.queryString)

        case .search(let query):
            return .requestParameters(parameters: ["query": query, "api_key": API.apiKey], encoding: URLEncoding.queryString)
        }
    }

    var headers: [String: String]? {
        return nil
    }
}
