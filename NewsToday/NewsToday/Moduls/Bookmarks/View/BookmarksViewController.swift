import UIKit
import SnapKit

protocol BookmarksViewControllerProtocol: AnyObject {
    func reloadTableView()
}

final class BookmarksViewController: UIViewController, BookmarksViewControllerProtocol {

    //MARK: - Presenter
    var presenter: BookmarksPresenterProtocol!

    //MARK: - UI Components
    private let tableView = UITableView()

    private let titleLabelBig = UILabel.makeLabel(text: "Bookmarks",
                                                  font: UIFont.InterSemiBold(ofSize: 24),
                                                  textColor: UIColor.blackPrimary,
                                                  numberOfLines: 1)

    private let titleLabelSmall = UILabel.makeLabel(text: "Saved articles to the library", 
                                                    font: UIFont.InterRegular(ofSize: 16),
                                                    textColor: UIColor.greyPrimary,
                                                    numberOfLines: 1)

    private let emptyView = EmptyView()
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        presenter = BookmarksPresenter(bookmarksViewControllerProtocol: self)
        presenter.viewDidLoad()
        configureTableView()
        setupViews()
       
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        setupConstraints()
        navigationController?.setNavigationBarHidden(false, animated: true)
        presenter.viewDidLoad()
    }
    

    //MARK: - Public Methods
    
    func updateEmptyViewVisibility() {
            emptyView.isHidden = presenter.bookmarkCount > 0
        }
    
    func configureTableView() {
        tableView.rowHeight = 96
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BookmarkCell.self, forCellReuseIdentifier: BookmarkCell.reuseID)
    }
    
    func setupViews() {
        [titleLabelBig, titleLabelSmall, tableView, emptyView].forEach {view.addSubview($0) }
    }
}


extension BookmarksViewController: UITableViewDelegate, UITableViewDataSource {
    func reloadTableView() {
        tableView.reloadData()
        updateEmptyViewVisibility()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.bookmarkCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BookmarkCell.reuseID) as! BookmarkCell
       let bookmark = presenter.getBookmark(at: indexPath.row)
        cell.set(info: bookmark)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let article = presenter.getBookmark(at: indexPath.row)

        guard let articleText = article.title else { return }
        NetworkManager.shared.fetchData(for: articleText) { result in
            switch result {
            case .success(let searchResults):
                DispatchQueue.main.async {
                    let vc = DetailsViewController(data: searchResults.articles, tag: String(indexPath.row))
                    vc.data = searchResults.articles
                    self.navigationController?.pushViewController(vc, animated: true)
                }

            case .failure(let error):
                print("Error fetching search results: \(error)")
            }
        }
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter.didEditingDelete(at: indexPath)
        }
    }

}


extension BookmarksViewController {
    func setupConstraints() {
            titleLabelBig.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(72)
        }
        titleLabelSmall.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(112)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(168)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }

        emptyView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
