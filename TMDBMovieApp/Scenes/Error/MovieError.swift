enum MovieError: Error, Equatable {
    case commonError(CommonError)
    case getMoviesFailed
}
