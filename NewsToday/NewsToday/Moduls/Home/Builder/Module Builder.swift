import UIKit

// MARK: HomeModuleBuilderProtocol

protocol HomeModuleBuilderProtocol {
    func createHomeModule(router: HomeRouterProtocol) -> UIViewController
    func createSearchVC(searchText: String) -> UIViewController
    func createSeeAllVC() -> UIViewController
    func createDetailsVC(data: [Article], tag: String) -> UIViewController
}

// MARK: Home Builder

final class HomeModuleBuilder: HomeModuleBuilderProtocol {

    func createHomeModule(router: HomeRouterProtocol) -> UIViewController {
        let view = HomeViewController()
        let presenter = HomePresenter(view: view as HomeViewControllerProtocol, router: router )
        view.presenter = presenter
        return view
    }

    func createSearchVC(searchText: String) -> UIViewController {
        SearchArticlesViewController(searchText: searchText)
    }

    func createSeeAllVC() -> UIViewController {
        //создать нужный VC, пока поставил заглушку чтобы не алярмило
        CategoriesViewController()
    }

    func createDetailsVC(data: [Article], tag: String) -> UIViewController {
        DetailsViewController(data: data, tag: tag)
    }
}
