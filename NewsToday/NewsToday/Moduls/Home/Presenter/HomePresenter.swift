import UIKit

protocol HomePresenterProtocol {
    var router: HomeRouterProtocol? {get set}
    var articles: [Article] { get set }
    func showSearchVC()
    func showSeeAllVC() -> Void
    func showDetailsVC(data: Article, tag: String)

    func getCategoryArrayCount() -> Int
    func getArticleArrayCount() -> Int
    func getRecommendedArrayCount() -> Int
    
    func getCategory(at index: IndexPath) -> String
    func getArticle(at index: Int) -> Article
    func getRecommended(at index: IndexPath) -> SearchResults
    
    func topHeadlinesTest(category: String)
    func loadAndFetchCategories()
    func clearRecommended()
}

final class HomePresenter: HomePresenterProtocol {

    private unowned var view: HomeViewControllerProtocol
    var router: HomeRouterProtocol?
    var articles: [Article] = []

    init(view: HomeViewControllerProtocol, router: HomeRouterProtocol) {
        self.view = view
        self.router = router
    }

    var categoryArray = [
        "Business",
        "Entertainment",
        "General",
        "Health",
        "Science",
        "Sports",
        "Technology"
    ]

    var articleArray = [Article]()
    var searchText: String = "apple"

    var recommendedArray = [SearchResults]()
    
    func clearRecommended() {
        recommendedArray.removeAll()
    }

    func showSearchVC() {
        router?.showSearchVC(searchText: searchText)
    }

    func showSeeAllVC() -> Void {
        router?.showSeeAllVC()
    }

    func showDetailsVC(data: Article, tag: String) {
        router?.showDetailsVC(data: [data], tag: tag)
    }

    func getCategoryArrayCount() -> Int {
        categoryArray.count
    }

    func getArticleArrayCount() -> Int {
        articleArray.count
    }
    func getRecommendedArrayCount() -> Int {
        recommendedArray.count
    }

    func getCategory(at index: IndexPath) -> String {
         categoryArray[index.row]
    }

    func getArticle(at index: Int) -> Article {
         articleArray[index]
    }
    func getRecommended(at index: IndexPath) -> SearchResults {
        recommendedArray[index.row]
    }

    func topHeadlinesTest(category: String) { NetworkManager.shared.fetchTopHeadlines(category: category) { result in
            switch result {
            case .success(let category):
                self.articleArray = category.articles
                DispatchQueue.main.async {
                    self.view.reloadCollectionView(section: 1)
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    func loadAndFetchCategories() {
        let userDefaultsManager = UserDefaultsManager()
        if let savedCategories = userDefaultsManager.getStringArray(forKey: .selectedCategories) {
            NetworkManager.shared.fetchCategories(for: savedCategories) { categoryName, result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let searchResults):
                        self.recommendedArray.append(searchResults)
                        DispatchQueue.main.async {
                            self.view.reloadCollectionView(section: 2)
                        }
                    case .failure(let error):
                        print("Error fetching data for \(categoryName):", error)
                    }
                }
            }
        }
    }
}
