import UIKit

protocol MovieListView: AnyObject {
    var presenter: MovieListPresenterInput { get }

    func updateTableView()
}

final class MovieListViewController: UIViewController {
    private(set) var presenter: MovieListPresenterInput

    private lazy var tableview: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.backgroundColor = .clear
        tableView.alwaysBounceVertical = false
        tableView.cellLayoutMarginsFollowReadableWidth = true
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MovieCell.self, forCellReuseIdentifier: MovieCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
        return tableView
    }()

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(loadMoreData), for: .valueChanged)
        return refreshControl
    }()

    init(presenter: MovieListPresenterInput) {
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
        localizeViews()
        setupConstraints()
        presenter.viewDidLoad()
    }

    private func customizeViews() {
        view.backgroundColor = .white
        view.addSubview(tableview)
    }

    private func localizeViews() {
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            setTableViewConstrints()
        ])
    }

    private func setTableViewConstrints() -> [NSLayoutConstraint] {
        [
            tableview.frameLayoutGuide.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableview.frameLayoutGuide.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableview.frameLayoutGuide.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableview.frameLayoutGuide.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
    }

}

// MARK: - Actions

private extension MovieListViewController {
    @objc func loadMoreData() {
        presenter.fetchMoreMovies()
    }
}

extension MovieListViewController: MovieListView {
    func updateTableView() {
        tableview.reloadData()
        refreshControl.endRefreshing()
    }
}

// MARK: - Delegate

extension MovieListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.movies?.count ?? 0
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let count = presenter.movies?.count else { return  }
        if indexPath.row == count - 5 {
            loadMoreData()
        }
    }
}

// MARK: - DataSource

extension MovieListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MovieCell = tableview.dequeueReusableCell(for: indexPath)
        guard let movies = presenter.movies else { return UITableViewCell() }
        cell.configure(movie: movies[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didTapCell(at: indexPath.row)
    }
}
