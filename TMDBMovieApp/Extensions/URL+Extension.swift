import Foundation

extension URL {
    static func getImageURL(size: String = "w500", posterPath: String) -> URL? {
        URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
    }
}
