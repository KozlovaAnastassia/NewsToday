import UIKit

// MARK: ProfileModuleBuilderProtocol

protocol ProfileModuleBuilderProtocol {
    func createProfileModule(router: ProfileRouterProtocol) -> UIViewController
    func createTermsVC() -> UIViewController
    func createLanguagesVC() -> UIViewController
    func createLoginVC() -> UIViewController
}

// MARK: Profile Builder

final class ProfileModuleBuilder: ProfileModuleBuilderProtocol {

    func createProfileModule(router: ProfileRouterProtocol) -> UIViewController {
        let view = ProfileViewController()
        let presenter = ProfilePresenter(view: view, router: router)
        view.presenter = presenter
        return view
    }

    func createTermsVC() -> UIViewController {
        TermsVC()
    }

    func createLanguagesVC() -> UIViewController {
        LanguageViewController()
    }

    func createLoginVC() -> UIViewController {
        SignInViewController()
    }
}
