protocol MoviesErrorHandleable: CommonErrorHandleable {
    func handleError(_ error: MovieError)
}

extension MoviesErrorHandleable {
    func handleError(_ error: MovieError) {
        guard let errorView = view as? ErrorDisplayableViewController else {
            assertionFailure("View does not implement ErrorDisplayable protocol")
            return
        }

        switch error {
        case .commonError(let commonError):
            handleCommonError(commonError)
        case .getMoviesFailed:
            errorView.showError(true, completion: nil)
        }
    }
}
