//
//  CustomHeader.swift
//  NewsToday
//
//  Created by Анастасия on 19.03.2024.
//

import UIKit

protocol CustomHeaderViewDelegate {
    func searchBarTextDidChange(_ searchBar: UISearchBar, newText: String)
    func searchBarSearchButtonClicked(with text: String)
}

final class CustomHeaderView: UICollectionReusableView, UISearchBarDelegate, SearchBarViewDelegate {

    var delegate: CustomHeaderViewDelegate?

    //MARK: -> Properties
    static var reuseIdentifier: String {"\(Self.self)"}



    private let descriptionLabel = UILabel.makeLabel(text: Constants.homeDescription,
                                                     font: UIFont.InterRegular(ofSize: 16),
                                                     textColor: UIColor.greyPrimary,
                                                     numberOfLines: .zero)

    private let searchBar = SearchBarView()

    private lazy var verticalStack: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .firstBaseline
        stack.axis = .vertical
        stack.addArrangedSubview(descriptionLabel)
        stack.addArrangedSubview(searchBar)
        //  stack.spacing = 20
        return stack
    }()

    //MARK: -> init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
        searchBar.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError(Errors.fatalError)
    }

    //MARK: -> Function
    private func setViews() {
        addSubview(verticalStack)

        searchBar.snp.makeConstraints {
            $0.height.equalTo(56)
            $0.trailing.leading.equalToSuperview()
        }
        verticalStack.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        // здесь можно добавить функционал для поведения при вводе текста в сёрч

        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
//        print("text changed now")
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text, !searchText.isEmpty {
            delegate?.searchBarSearchButtonClicked(with: searchText)
        }
    }
}
