import UIKit

// sourcery: AutoMockable
protocol MovieListView: AnyObject {
    var presenter: MovieListPresenterInput { get }

    func updateTableView()
}

final class MovieListViewController: UIViewController {
    private(set) var presenter: MovieListPresenterInput

    private enum Constants {
        static let buttonHeight: CGFloat = 50
    }

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

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Search"
        searchBar.sizeToFit()
        return searchBar
    }()

    private lazy var switchPreferedMoviesButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Switch Prefered Movies", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(changePreferedMovies), for: .touchUpInside)
        return button
    }()

    private let debouncer = Debouncer()

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
        setupConstraints()
        presenter.viewDidLoad()
    }

    private func customizeViews() {
        view.backgroundColor = .white
        view.addSubview(tableview)
        view.addSubview(switchPreferedMoviesButton)
        navigationItem.titleView = searchBar
    }
}

// MARK: - Actions

private extension MovieListViewController {
    @objc func loadMoreData() {
        presenter.fetchMoreMovies()
    }

    @objc func changePreferedMovies() {
        presenter.changePreferedMovies()
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
        tableview.deselectRow(at: indexPath, animated: false)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 166
    }
}

// MARK: - UISearchBarDelegate
extension MovieListViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        debouncer.debounce(delay: 1) { [weak self] in
            self?.presenter.searchMovies(text: searchText)
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter.searchMovies(text: "")
        searchBar.resignFirstResponder()
    }
}

// MARK: - Constraints
extension MovieListViewController {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            setTableViewConstrints(),
            setswitchPreferedMoviesButtonConstrints()
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

    private func setswitchPreferedMoviesButtonConstrints() -> [NSLayoutConstraint] {
        [
            switchPreferedMoviesButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -Layouts.marginLarge).with(priority: 1),
            switchPreferedMoviesButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Layouts.marginLarge),
            switchPreferedMoviesButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Layouts.marginLarge),
            switchPreferedMoviesButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight)
        ]
    }
}
