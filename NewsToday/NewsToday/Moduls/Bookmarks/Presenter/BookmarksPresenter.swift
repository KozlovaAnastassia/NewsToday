import UIKit

protocol BookmarksPresenterProtocol {
    var bookmarkCount: Int { get }
    func getBookmark(at index: Int) -> Article
    func viewDidLoad()
    func didEditingDelete(at indexPath: IndexPath)
    func retrieveBookmarks()
}

final class BookmarksPresenter: BookmarksPresenterProtocol {
    weak private var bookmarksViewControllerProtocol: BookmarksViewControllerProtocol?
    
    var bookmarks: [Article] = []
    
    init(bookmarksViewControllerProtocol: BookmarksViewControllerProtocol? = nil) {
        self.bookmarksViewControllerProtocol = bookmarksViewControllerProtocol
    }
    
    var bookmarkCount: Int {
        return bookmarks.count
    }
    
    func getBookmark(at index: Int) -> Article {
        return bookmarks[index]
    }
    
    
    func viewDidLoad() {
        bookmarksViewControllerProtocol?.reloadTableView()
        retrieveBookmarks()
    }


    func didEditingDelete(at indexPath: IndexPath) {
        guard indexPath.row < bookmarks.count else { return }
        let articleToDelete = bookmarks[indexPath.row]
        let articleId = articleToDelete.title
        
        PersistenceManager.updateWith(favorite: articleToDelete, actionType: .remove) { error in
            if let error = error {
                print("Error: \(error)")
            }
        }
        UserDefaults.standard.set(false, forKey: articleId ?? "")
        bookmarks.remove(at: indexPath.row)
        bookmarksViewControllerProtocol?.reloadTableView()
    }

    func retrieveBookmarks() {
         PersistenceManager.retrieveFavorites { [weak self] result in
             guard let self = self else { return }
             switch result {
             case .success(let favorites):
                 self.bookmarks = favorites
                 self.bookmarksViewControllerProtocol?.reloadTableView()
             case .failure(let error):
                 print(error)
             }
         }
     }
}
