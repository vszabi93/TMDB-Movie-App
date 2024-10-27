import UIKit

protocol CommonErrorHandleable {
    associatedtype ErrorView

    var view: ErrorView? { get set }

    func handleCommonError(_ error: CommonError)
}

extension CommonErrorHandleable {
    func handleCommonError(_ error: CommonError) {
        guard let errorView = view as? ErrorDisplayableViewController else {
            assertionFailure("View does not implement ErrorDisplayable protocol")
            return
        }

        switch error {
        case .noInternet:
            errorView.showError(true, completion: nil)
        }
    }
}
