import UIKit

class MovieCell: UITableViewCell {

//    Movie Title (Main text, larger font)
//
//    Release Date (Subtext under the movie title)
//
//    Poster Thumbnail (Displayed on the left)
//
//    Rating (Shown as a small visual indicator, like stars or a numerical value)

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    func configure (movie: MovieResult) {}
}
