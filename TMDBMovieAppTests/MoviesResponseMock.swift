@testable import TMDBMovieApp

let moviessResponsMock: MovieResponse = .init(
    page: 1,
    totalResults: 30,
    totalPages: 5,
    results: [.init(
        popularity: .zero,
        voteCount: .zero,
        video: false,
        posterPath: "",
        id: .zero,
        adult: false,
        backdropPath: "",
        originalTitle: "",
        genreIDS: [.zero],
        title: "",
        voteAverage: .zero,
        overview: "",
        releaseDate: ""
    )]
)
