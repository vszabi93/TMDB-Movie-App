import Kingfisher
import UIKit

class MovieCell: UITableViewCell {

    private enum Constants {
        static let posterSize: CGSize = .init(width: 100, height: 150)
        static let starImageSize: CGSize = .init(width: 13, height: 13)
    }

//    Poster Thumbnail (Displayed on the left)

    private let poster: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.layer.cornerRadius = 16
        return image
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, releaseLabel, voteStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = Layouts.marginSmall
        stackView.setCustomSpacing(Layouts.marginLarge, after: voteStackView)
        return stackView
    }()

    //    Movie Title (Main text, larger font)

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = .zero
        label.font = UIFont(tmdbFont: .large)
        return label
    }()

    //    Release Date (Subtext under the movie title)

    private let releaseLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = .zero
        label.font = UIFont(tmdbFont: .small)
        return label
    }()

    //    Rating (Shown as a small visual indicator, like stars or a numerical value)

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

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(poster)
        contentView.addSubview(stackView)
        setupConstraints()

    }

    func configure(movie: MovieResult) {
        titleLabel.text = movie.title
        releaseLabel.text = movie.releaseDate
        let url = URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath ?? "")")
        poster.kf.setImage(with: url)
        voteAvarageLabel.text = "\(movie.voteAverage ?? .zero)"
    }
}

extension MovieCell {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            setPosterConstraints(),
            setTitleLabelConstraints(),
            setStarImageConstraitns()
        ])
    }

    private func setPosterConstraints() -> [NSLayoutConstraint] {
        [
            poster.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Layouts.marginSmall),
            poster.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Layouts.marginSmall),
            poster.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Layouts.marginSmall),
            poster.heightAnchor.constraint(equalToConstant: Constants.posterSize.height),
            poster.widthAnchor.constraint(equalToConstant: Constants.posterSize.width)
        ]
    }

    private func setTitleLabelConstraints() -> [NSLayoutConstraint] {
        [
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Layouts.marginSmall),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Layouts.marginSmall),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Layouts.marginSmall).with(priority: 1),
            stackView.leadingAnchor.constraint(equalTo: poster.trailingAnchor, constant: Layouts.marginLarge)
        ]
    }

    private func setStarImageConstraitns() -> [NSLayoutConstraint] {
        [
            starImage.heightAnchor.constraint(equalToConstant: Constants.starImageSize.height),
            starImage.widthAnchor.constraint(equalToConstant: Constants.starImageSize.width)
        ]
    }
}
