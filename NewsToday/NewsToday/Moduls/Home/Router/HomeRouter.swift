import UIKit

// MARK: - HomeRouterProtocol

protocol HomeRouterProtocol: BaseRouter {
    func start()
    func showSearchVC(searchText: String)
    func showSeeAllVC()
    func showDetailsVC(data: [Article], tag: String)
    func initialViewController()
}

// MARK: HomeRouter

final class HomeRouter: HomeRouterProtocol {

    let navigationController: UINavigationController
    var moduleBuilder: (any HomeModuleBuilderProtocol)?
    private let factory: AppFactory

    init(navigationController: UINavigationController,
         factory: AppFactory,
         builder: HomeModuleBuilderProtocol) {
        self.navigationController = navigationController
        self.moduleBuilder = builder
        self.factory = factory
    }
    
    func initialViewController() {
        if let homeVC = moduleBuilder?.createHomeModule(router: self) {
            navigationController.viewControllers = [homeVC]
        }
    }
    
    func start() {
        navigationController.viewControllers = [factory.makeHomeViewController()]
    }

    func showSearchVC(searchText: String) {
        guard let searchVC = moduleBuilder?.createSearchVC(searchText: searchText) else { return }
        navigationController.pushViewController(searchVC, animated: true)
    }

    func showSeeAllVC() {
        guard let vc = moduleBuilder?.createSeeAllVC() else { return }
        navigationController.pushViewController(vc, animated: true)
    }

    func showDetailsVC(data: [Article], tag: String) {
        guard let vc = moduleBuilder?.createDetailsVC(data: data, tag: tag) else { return }
        navigationController.pushViewController(vc, animated: true)
    }
}
