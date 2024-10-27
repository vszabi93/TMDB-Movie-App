import SwiftyMocky
@testable import TMDBMovieApp
import XCTest

final class TMDBMovieListPresenterTests: XCTestCase {
    private let mockMovies = moviessResponsMock
    private var sut: MovieListPresenter!

    // MARK: - Dependencies

    private var coordinator: MovieCoordinatorInputMock!
    private var interactor: MovieListInteractorInputMock!
    private var view: MovieListViewMock!

    override func setUpWithError() throws {
        try super.setUpWithError()
        coordinator = MovieCoordinatorInputMock()
        interactor = MovieListInteractorInputMock()
        view = MovieListViewMock()

        sut = MovieListPresenter(
            coordinator: coordinator,
            interactor: interactor
        )
        sut.view = view
    }

    override func tearDownWithError() throws {
        sut = nil

        interactor = nil
        coordinator = nil
        view = nil
        try super.tearDownWithError()
    }

    func test_viewDidLoad_whenCurrentIndexZero_shouldCallUpdateDetails() {
        Perform(interactor, .getPopularMovies(page: .value(.zero), completion: .any, perform: { _, completion in
            completion(.success(self.mockMovies))
        }))

        sut.viewDidLoad()

        Verify(view, 1, .updateTableView())
    }
}
