import UIKit

// MARK: - ProfileRouterProtocol

protocol RouterProtocol {
    var navigationController: UINavigationController? { get set }
    var moduleBuilder: ProfileModuleBuilderProtocol? { get set }
}

protocol ProfileRouterProtocol: RouterProtocol {
    func start()
    func showTermsVC()
    func showLanguagesVC()
    func showLoginVC()
}

// MARK: ProfileRouter

final class ProfileRouter: ProfileRouterProtocol {

    var navigationController: UINavigationController?
    var moduleBuilder: ProfileModuleBuilderProtocol?
    private let factory: AppFactory

    init(navigationController: UINavigationController,
         factory: AppFactory,
         builder: ProfileModuleBuilderProtocol)
    {
        self.navigationController = navigationController
        self.factory = factory
        self.moduleBuilder = builder
    }

    func start() {
        //        navigationController?.viewControllers = [factory.makeProfileViewController()]
        if let navigationController = navigationController {
            guard let profileVC = moduleBuilder?.createProfileModule(router: self) else { return }
            navigationController.viewControllers = [profileVC]
        }
    }

    func showTermsVC() {
        guard let termsVC = moduleBuilder?.createTermsVC() else { return }
        navigationController?.pushViewController(termsVC, animated: true)
    }

    func showLanguagesVC() {
        guard let languageVC = moduleBuilder?.createLanguagesVC() else { return }
        navigationController?.pushViewController(languageVC, animated: true)
    }

    func showLoginVC() {
        guard let loginVC = moduleBuilder?.createLoginVC() else { return }
        navigationController?.pushViewController(loginVC, animated: true)
    }
}
