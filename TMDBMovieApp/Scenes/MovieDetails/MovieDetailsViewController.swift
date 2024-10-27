import UIKit

protocol MovieDetailsView: AnyObject {
    var presenter: MovieDetailsPresenterInput { get }

    func updateDetails(with model: MovieDetailResponse)
}
// swiftlint:disable file_types_order
final class MovieDetailsViewController: UIViewController {
    private(set) var presenter: MovieDetailsPresenterInput

    init(presenter: MovieDetailsPresenterInput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        customizeViews()
        setupConstraints()
        presenter.viewDidLoad()

    }

    private func customizeViews() {}
}

// MARK: - Actions

extension MovieDetailsViewController {
    @objc private func didBackButtonTapped() {
        presenter.didTapBackButton()
    }
}

extension MovieDetailsViewController: MovieDetailsView {
    func updateDetails(with model: MovieDetailResponse) {}
}

// MARK: - Constraints

extension MovieDetailsViewController {
    private func setupConstraints() {}
}
