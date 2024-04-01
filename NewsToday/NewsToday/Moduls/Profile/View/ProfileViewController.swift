import UIKit

protocol ProfileViewControllerProtocol: AnyObject {

}

final class ProfileViewController: UIViewController {

    //MARK: - Presenter
    var presenter: ProfilePresenterProtocol!

    // MARK: - UI Elements

    let profileTitle = UILabel.makeLabel(text: "Profile",
                                         font: UIFont.InterBold(ofSize: 24),
                                         textColor: .blackPrimary,
                                         numberOfLines: nil)

    private let profileImage: UIImageView = {
        let element = UIImageView()
        element.image = UIImage(named: "profileFoto")
        element.layer.cornerRadius = 35
        element.clipsToBounds = true
        return element
    }()

    private let profileName = UILabel.makeLabel(text: "This is you",
                                                font: UIFont.InterSemiBold(ofSize: 16),
                                                textColor: UIColor.blackDark,
                                                numberOfLines: 1)

    private let profileEmail = UILabel.makeLabel(text: "dev@gmail.com",
                                                 font: UIFont.InterSemiBold(ofSize: 14),
                                                 textColor: UIColor.greyLight,
                                                 numberOfLines: 1)

    private lazy var languageButton: UIButton = {
        var config = UIButton.Configuration.plain()

        config.image = UIImage(named: "angleRight")
        config.imagePlacement = .trailing
        config.imagePadding = self.calculateDynamicPadding()

        let button = UIButton(configuration: config, primaryAction: nil)
        button.setTitle("Language", for: .normal)
        button.titleLabel?.numberOfLines = 1
        button.titleLabel?.font = .InterSemiBold(ofSize: 16)
        button.layer.cornerRadius = 12
        button.backgroundColor = .greyLighter
        button.tintColor = .darkGray

        button.addTarget(self, action: #selector(languageButtonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: -> Butttons
    private lazy var termsButton: UIButton = {
        var config = UIButton.Configuration.plain()

        config.image = UIImage(named: "angleRight")
        config.imagePlacement = .trailing
        config.imagePadding = self.calculateDynamicPadding()

        let button = UIButton(configuration: config, primaryAction: nil)
        button.setTitle("Terms & Conditions", for: .normal)
        button.titleLabel?.numberOfLines = 1
        button.titleLabel?.font = .InterSemiBold(ofSize: 16)
        button.layer.cornerRadius = 12
        button.backgroundColor = .greyLighter
        button.tintColor = .darkGray

        button.addTarget(self, action: #selector(termsButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var signoutButton: UIButton = {
        var config = UIButton.Configuration.plain()

        config.image = UIImage(named: "signout")
        config.imagePlacement = .trailing
        config.imagePadding = self.calculateDynamicPadding()

        let button = UIButton(configuration: config, primaryAction: nil)
        button.setTitle("Sign Out", for: .normal)
        button.titleLabel?.numberOfLines = 1
        button.titleLabel?.font = .InterSemiBold(ofSize: 16)
        button.layer.cornerRadius = 12
        button.backgroundColor = .greyLighter
        button.tintColor = .darkGray

        button.addTarget(self, action: #selector(signoutButtonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }

    //MARK: Private Methods
    private func setupViews() {

        view.backgroundColor = .white

        [languageButton, profileTitle, profileImage, profileName, profileEmail, termsButton, signoutButton].forEach { view.addSubview($0)}
    }

    private func calculateDynamicPadding() -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width

        if screenWidth > 500 {
            return 250
        } else {
            return 200
        }
    }

    // MARK: Selector Methods
    @objc
    private func languageButtonTapped() {
        print("language button tapped")
        self.presenter.showLanguagesVC()
    }

    @objc
    private func termsButtonTapped() {
        print("terms button tapped")
        self.presenter.showTermsVC()
    }

    @objc
    private func signoutButtonTapped() {
        print("signout button tapped")
        self.presenter.showLoginVC()
    }
}

private extension ProfileViewController {

    func setupConstraints() {

        languageButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(208)
            make.height.equalTo(56)
        }

        profileTitle.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(28)
            make.left.equalTo(view).inset(20)
        }

//        pageTitle.snp.makeConstraints { make in
//            make.top.equalTo(view.safeAreaLayoutGuide).inset(28)
//            make.left.equalTo(view).inset(20)
//            make.width.equalTo(201)
//            make.height.equalTo(136)
//        }

        profileImage.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(92)
            make.left.equalTo(view).inset(20)
            make.width.equalTo(72)
            make.height.equalTo(72)
        }

        profileName.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(104)
            make.left.equalTo(view).inset(116)
            make.width.equalTo(60)
            make.height.equalTo(24)
        }

        profileEmail.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(128)
            make.left.equalTo(view).inset(116)
            make.width.equalTo(115)
            make.height.equalTo(24)
        }

        termsButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view).inset(208)
            make.height.equalTo(56)
        }

        signoutButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view).inset(124)
            make.height.equalTo(56)
        }
    }
}

extension ProfileViewController: ProfileViewControllerProtocol {

}
