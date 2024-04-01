//
//  CategoriesCustomCell.swift
//  NewsToday
//
//  Created by Анастасия on 19.03.2024.
//

import UIKit

final class CategoriesCustomCell: UICollectionViewCell {

    //MARK: -> Properties
    static var reuseIdentifier: String {"\(Self.self)"}

     let titleButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.greyPrimary, for: .normal)
        button.titleLabel?.font = UIFont.InterRegular(ofSize: 14)
        button.backgroundColor = .greyLighter
        button.layer.cornerRadius = 16
        return button
    }()

    //MARK: -> init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError(Errors.fatalError)
    }

    //MARK: -> Functions
    private func setupViews() {
        addSubview(titleButton)

        titleButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    override func prepareForReuse() {
        titleButton.removeTarget(nil, action: nil, for: .allEvents)
    }

    func selectCell() {
        self.titleButton.backgroundColor = .purplePrimary
        self.titleButton.setTitleColor(UIColor.white, for: .normal)
    }
    
    func deselectCell(){
        self.titleButton.backgroundColor = .greyLighter
        self.titleButton.setTitleColor(UIColor.greyPrimary, for: .normal)   
    }

    func configure(titleCategory: String, isSelected: Bool, handler: @escaping () -> Void) {
        titleButton.setTitle(titleCategory, for: .normal)
        if isSelected {
            selectCell()
        } else {
            deselectCell()
        }
        titleButton.removeTarget(nil, action: nil, for: .allEvents) // Удаляем предыдущие actions
        let action = UIAction { _ in handler() }
        titleButton.addAction(action, for: .touchUpInside)
    }
}

