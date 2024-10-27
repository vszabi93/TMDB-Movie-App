import Kingfisher
import UIKit

protocol MovieDetailsView: AnyObject {
    var presenter: MovieDetailsPresenterInput { get }

    func updateDetails(with model: MovieDetailResponse)
}

final class MovieDetailsViewController: UIViewController {
    private(set) var presenter: MovieDetailsPresenterInput

    private let Str = Rsc.Movie.MovieDetails.self // swiftlint:disable:this identifier_name

    private enum Constants {
        static let starImageSize: CGSize = .init(width: 20, height: 20)
    }

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentInsetAdjustmentBehavior = .always
        scrollView.backgroundColor = .white
        scrollView.addSubview(poster)
        scrollView.addSubview(titleStackView)
        scrollView.addSubview(genresLabel)
        scrollView.addSubview(statusStackView)
        scrollView.addSubview(overviewLabel)
        return scrollView
    }()

    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, releaseLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = Layouts.marginSmall
        return stackView
    }()

//    Movie Title (Large, main heading at the top)
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = .zero
        label.font = UIFont(tmdbFont: .extraLargeBold)
        label.textColor = .black
        return label
    }()

//    Release Date (Displayed below the movie title)
    private let releaseLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = .zero
        label.font = UIFont(tmdbFont: .large)
        label.textColor = .gray

        return label
    }()

//    Full-size Poster Image (A larger image displayed prominently on the page)

    private let poster: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 20
        return image
    }()

    //    Overview (A brief summary of the movie’s plot)

    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = .zero
        label.font = UIFont(tmdbFont: .small)
        label.textColor = .gray
        return label
    }()

//    Genres (Displayed under or beside the poster)

    private let genresLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = .zero
        label.font = UIFont(tmdbFont: .small)
        label.textColor = .gray
        return label
    }()

    private lazy var statusStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [ratingStackView, languageStackView, runtimeStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = Layouts.marginSmall
        return stackView
    }()

//    Rating (Displayed as a visual indicator, like stars or a numerical rating)

    private lazy var ratingStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [ratingLabel, voteStackView])
        stackView.axis = .vertical
        stackView.spacing = Layouts.marginSmall
        return stackView
    }()

    private lazy var languageStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [languageLabel, languageValueLabel])
        stackView.axis = .vertical
        stackView.spacing = Layouts.marginSmall
        return stackView
    }()

    private lazy var runtimeStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [runtimeLabel, runtimeValueLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = Layouts.marginSmall
        return stackView
    }()

    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = .zero
        label.text = Str.Rating.title
        label.font = UIFont(tmdbFont: .smallBold)
        return label
    }()

    private lazy var runtimeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = .zero
        label.text = Str.Runtime.title
        label.font = UIFont(tmdbFont: .smallBold)
        return label
    }()

    private lazy var languageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = .zero
        label.text = Str.Language.title
        label.font = UIFont(tmdbFont: .smallBold)
        return label
    }()

    private lazy var voteStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [starImage, voteAvarageLabel])
        stackView.axis = .horizontal
        stackView.spacing = Layouts.marginSmall
        return stackView
    }()

    private let starImage: UIImageView = {
        let image = UIImageView(image: Asset.star.image)
        image.contentMode = .scaleAspectFit
        return image
    }()

    private let voteAvarageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = .zero
        label.font = UIFont(tmdbFont: .smallBold)
        return label
    }()

    //    Runtime (Displayed in hours and minutes)

    private let runtimeValueLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = .zero
        label.font = UIFont(tmdbFont: .smallBold)
        return label
    }()

    //    Language (The primary language of the movie, e.g., English, French, etc.)

    private let languageValueLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = .zero
        label.font = UIFont(tmdbFont: .smallBold)
        return label
    }()

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

    private func customizeViews() {
        view.addSubview(scrollView)
        view.backgroundColor = .white
    }
}

// MARK: - Actions

extension MovieDetailsViewController {
    @objc private func didBackButtonTapped() {
        presenter.didTapBackButton()
    }
}

extension MovieDetailsViewController: MovieDetailsView {
    func updateDetails(with model: MovieDetailResponse) {
        titleLabel.text = model.title
        releaseLabel.text = model.releaseDate
        overviewLabel.text = model.overview
        voteAvarageLabel.text = "\(model.voteAverage ?? .zero)"
        languageValueLabel.text = model.originalLanguage
        runtimeValueLabel.text = "\(model.runtimeInHourAndMinutes.hours) h \(model.runtimeInHourAndMinutes.minutes) m"
        genresLabel.text = model.genres?.compactMap(\.name).joined(separator: ", ")
        poster.kf.setImage(with: URL.getImageURL(posterPath: model.posterPath ?? ""))
    }
}

// MARK: - Constraints

extension MovieDetailsViewController {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            setScrollViewConstraints(),
            setPosterViewConstraints(),
            setTitleStackViewConstraints(),
            setGenresLabelConstraints(),
            setStatusStackViewConstraints(),
            setStarImageConstraitns(),
            setOverviewLabelConstraints()
        ])
    }

    private func setScrollViewConstraints() -> [NSLayoutConstraint] {
        [
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: scrollView.contentLayoutGuide.widthAnchor),
            scrollView.contentLayoutGuide.heightAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.heightAnchor)
        ]
    }

    private func setPosterViewConstraints() -> [NSLayoutConstraint] {
        [
            poster.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: Layouts.marginLarge),
            poster.topAnchor.constraint(equalTo: titleStackView.bottomAnchor, constant: Layouts.marginLarge),
            poster.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -Layouts.marginLarge),
            poster.heightAnchor.constraint(equalTo: poster.widthAnchor, multiplier: 3/2)
        ]
    }

    private func setTitleStackViewConstraints() -> [NSLayoutConstraint] {
        [
            titleStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: Layouts.marginSmall),
            titleStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: Layouts.marginLarge),
            titleStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -Layouts.marginLarge),
            titleStackView.bottomAnchor.constraint(equalTo: overviewLabel.topAnchor, constant: -Layouts.marginLarge).with(priority: 1)
        ]
    }

    private func setGenresLabelConstraints() -> [NSLayoutConstraint] {
        [
            genresLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: Layouts.marginLarge),
            genresLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -Layouts.marginLarge),
            genresLabel.topAnchor.constraint(equalTo: poster.bottomAnchor, constant: Layouts.marginLarge)
        ]
    }

    private func setStatusStackViewConstraints() -> [NSLayoutConstraint] {
        [
            statusStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: Layouts.marginLarge),
            statusStackView.topAnchor.constraint(equalTo: genresLabel.bottomAnchor, constant: Layouts.marginLarge),
            statusStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -Layouts.marginLarge),
            statusStackView.bottomAnchor.constraint(equalTo: overviewLabel.topAnchor, constant: -Layouts.marginLarge)
        ]
    }

    private func setOverviewLabelConstraints() -> [NSLayoutConstraint] {
        [
            overviewLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: Layouts.marginLarge),
            overviewLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -Layouts.marginLarge),
            overviewLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -Layouts.marginLarge)
        ]
    }

    private func setStarImageConstraitns() -> [NSLayoutConstraint] {
        [
            starImage.heightAnchor.constraint(equalToConstant: Constants.starImageSize.height),
            starImage.widthAnchor.constraint(equalToConstant: Constants.starImageSize.width)
        ]
    }

}
