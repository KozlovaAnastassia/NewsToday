//
//  PopularCustomCell.swift
//  NewsToday
//
//  Created by Анастасия on 19.03.2024.
//

import UIKit

final class PopularCustomCell: UICollectionViewCell {

    //MARK: -> Properties
    static var reuseIdentifier: String {"\(Self.self)"}

    private let titleLabel = UILabel.makeLabel(
                                        text: "",
                                        font: UIFont.InterRegular(ofSize: 12),
                                        textColor: UIColor.greyLighter,
                                        numberOfLines: nil
                                        )

    private let textLabel = UILabel.makeLabel(
                                    text: "",
                                    font: UIFont.InterBold(ofSize: 16),
                                    textColor:  UIColor.white,
                                    numberOfLines: .zero
                                    )
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        let overlayView = UIView()
           overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        imageView.addSubview(overlayView)
        overlayView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        return imageView
    }()

    private lazy var overlayButton: UIButton = {
        let button = UIButton(type: .custom)
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
       
        button.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        return button
    }()

    private lazy var verticalStack: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .leading
        stack.axis = .vertical
        stack.spacing = 10
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(textLabel)
        return stack
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
    
    override func prepareForReuse() {
        imageView.image = nil
        textLabel.text = ""
        titleLabel.text = ""
        overlayButton.removeTarget(nil, action: nil, for: .allEvents)
    }

    private func setupViews() {
        addSubview(overlayButton)
        overlayButton.addSubview(verticalStack)

        overlayButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        verticalStack.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-20)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
    }

    func configure(imageURL: String, title: String, text: String, id: String, handler: @escaping () -> Void) {

        DispatchQueue.main.async {
            self.imageView.loadImage(withURL: imageURL, id: id)
        }
        titleLabel.text = title
        textLabel.text = text
        
        let action = UIAction { _ in
            handler()
        }
        overlayButton.addAction(action, for: .touchUpInside)
    }
}
