//
//  LanguageViewController.swift
//  NewsToday
//
//  Created by Андрей Линьков on 23.03.2024.
//

import UIKit

protocol LanguageViewControllerProtocol: AnyObject {

}

final class LanguageViewController: UIViewController {

//    //MARK: - Presenter
//    var presenter: LanguagePresenterProtocol!
//

    // MARK: - UI Elements

    private let languagePageTitle = UILabel.makeLabel(text: "Language",
                                                          font: UIFont.InterBold(ofSize: 24),
                                                          textColor: .blackPrimary,
                                                          numberOfLines: nil)

    private lazy var engLanguageButton: UIButton = {
            var config = UIButton.Configuration.plain()

            config.image = UIImage(named: "Check img")
            config.imagePlacement = .trailing
            config.imagePadding = self.calculateDynamicPadding()

            let button = UIButton(configuration: config, primaryAction: nil)
            button.setTitle("English", for: .normal)
            button.titleLabel?.numberOfLines = 1
            button.titleLabel?.font = .InterSemiBold(ofSize: 16)
            button.layer.cornerRadius = 12
            button.backgroundColor = .greyLighter
            button.tintColor = .darkGray
            return button
          }()

        private func calculateDynamicPadding() -> CGFloat {
               let screenWidth = UIScreen.main.bounds.width

               if screenWidth > 500 {
                   return 250
               } else {
                   return 200
               }
           }

    private lazy var rusLanguageButton: UIButton = {
            var config = UIButton.Configuration.plain()

            config.image = UIImage(named: "Check img")
            config.imagePlacement = .trailing
            config.imagePadding = self.calculateDynamicPadding()

            let button = UIButton(configuration: config, primaryAction: nil)
            button.setTitle("Russian", for: .normal)
            button.titleLabel?.numberOfLines = 1
            button.titleLabel?.font = .InterSemiBold(ofSize: 16)
            button.layer.cornerRadius = 12
            button.backgroundColor = .greyLighter
            button.tintColor = .darkGray
            return button
          }()


    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
    }


    //MARK: Private Methods
    private func setupViews() {
        [ engLanguageButton, rusLanguageButton, languagePageTitle].forEach {view.addSubview($0)}
    }

    private func setupConstraints() {

        languagePageTitle.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.leading.trailing.equalToSuperview().inset(130)
            make.height.equalTo(32)
        }

        engLanguageButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(80)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(56)
        }

        rusLanguageButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(152)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(56)
        }
    }
}
