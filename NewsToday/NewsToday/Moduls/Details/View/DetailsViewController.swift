import UIKit
import SnapKit

protocol DetailsViewControllerProtocol: AnyObject {
    func displayData()
   
}

final class DetailsViewController: UIViewController, DetailsViewControllerProtocol, UITextViewDelegate, UIScrollViewDelegate {
    //MARK: - Presenter
    private let presenter = DetailsPresenter()


    //MARK: - Private properties
    var data = [Article]()
    var tag: String
    weak private var detailsPresenterProtocol: DetailsPresenterProtocol?
    var isArticleSaved = true

    //MARK: - UI Components
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true
        return scrollView
    }()
    private let contentView: UIView = {
        let view = UIView()
        return view
    }()
    private let contentImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        return image
    }()

    private let shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "share-icon"), for: .normal)
        return button
    }()

    private let labelView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.purplePrimary
        view.layer.cornerRadius = 16
        return view
    }()

    private let categoryLabel = UILabel.makeLabel(font: UIFont.InterSemiBold(ofSize: 12),
                                                  textColor: .white,
                                                  numberOfLines: 1)
    private let headlineLabel = UILabel.makeLabel(font: UIFont.InterBold(ofSize: 20),
                                                  textColor: .white,
                                                  numberOfLines: 2)
    private let authorLabel = UILabel.makeLabel(font: UIFont.InterSemiBold(ofSize: 16),
                                                textColor: .white,
                                                numberOfLines: 1)
    private let authorGreyLabel = UILabel.makeLabel(text: "Author",
                                                    font: UIFont.InterRegular(ofSize: 14), textColor: UIColor.greyLight,
                                                    numberOfLines: 1)
    private let titleLabel = UILabel.makeLabel(font: UIFont.InterSemiBold(ofSize: 16),
                                               textColor: UIColor.blackPrimary,
                                               numberOfLines: 0)
    private let contentTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.font = UIFont.InterRegular(ofSize: 16)
        textView.textColor = UIColor.greyDark
        return textView
    }()
    
    init(data: [Article], tag: String){
        self.data = data
        self.tag = tag
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

     private lazy var bookmarkButton = UIBarButtonItem(image: UIImage(systemName: "bookmark"), style: .plain, target: self, action: #selector(bookmarkButtonTapped))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        presenter.setDetailsViewControllerProtocol(detailsViewControllerProtocol: self)
        self.detailsPresenterProtocol = presenter
        configureController()
        setNavigationBar(title: "")
        updateBookmarkButtonColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.detailsPresenterProtocol?.getData(with: data)
        if let articleId = data.first?.title{
            isArticleSaved = UserDefaults.standard.bool(forKey: articleId)
        }
        updateBookmarkButtonColor()
    }
    // MARK: - Public Methods
    
    func displayData() {
        DispatchQueue.main.async {
            let urlString = self.data.first?.urlToImage
            let articleId = self.data.first?.source.id
            
            self.contentImage.loadImage(withURL: self.data.first?.urlToImage ?? "", placeholder: UIImage(named: "placeHolder"), id: self.tag)

          //было до этого в деве вместо предыдущей строки
//             self.contentImage.loadImage(withURL: urlString ?? "https://ionicframework.com/docs/img/demos/thumbnail.svg",
//                                         id: articleId ?? "")
          
            self.categoryLabel.text = self.data.first?.source.name
            self.headlineLabel.text = self.data.first?.title
            self.authorLabel.text = self.data.first?.author
            self.titleLabel.text = self.data.first?.title
            self.contentTextView.text = self.data.first?.content
        }
    }
    
    @objc func bookmarkButtonTapped() {
        guard let articleToSave = data.first else { return }
        let articleId = articleToSave.title
        if isArticleSaved {
            PersistenceManager.updateWith(favorite: articleToSave, actionType: .remove) { _ in }
            UserDefaults.standard.set(false, forKey: articleId ?? "")
            print("Article removed from favorites")
        } else {
            PersistenceManager.updateWith(favorite: articleToSave, actionType: .add) { error in
                if let error = error as? PersistenceError, error == .alreadyInFavorites {
                    print("Article is already in favorites")
                } else if let error = error {
                    print("Error saving article: \(error)")
                } else {
                    print("Article saved to favorites")
                }
            }
            UserDefaults.standard.set(true, forKey: articleId ?? "")
            print("Article added to favorites")
        }
        isArticleSaved.toggle()
        updateBookmarkButtonColor()
    }
    
    @objc func shareButtonTapped() {
        guard let textToShare = data.first?.url else { return }
        let activityViewController = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }

    // MARK: Private methods
    private func setupViews() {
        [contentImage, shareButton, labelView, categoryLabel, headlineLabel, authorLabel, authorGreyLabel, titleLabel, contentTextView].forEach {contentView.addSubview($0) }
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        labelView.addSubview(categoryLabel)
    }

   
    private func configureController() {
        bookmarkButton.tintColor = .white
        navigationItem.rightBarButtonItem = bookmarkButton
        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        view.backgroundColor = .systemBackground
        contentTextView.delegate = self
        scrollView.contentInsetAdjustmentBehavior = .never
    }


    private func updateBookmarkButtonColor() {
        let filledImage = UIImage(systemName: "bookmark.fill")
        let emptyImage = UIImage(systemName: "bookmark")
        let bookmarkImage = isArticleSaved ? filledImage : emptyImage 
        bookmarkButton.image = bookmarkImage
    }

    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }

        contentImage.snp.makeConstraints { make in
          make.top.equalToSuperview()
          make.leading.trailing.equalToSuperview()
          make.height.equalTo(384)

        }
        shareButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(120)
            make.trailing.equalToSuperview().offset(-16)
        }

        labelView.snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(32)
            make.width.equalTo(categoryLabel.snp.width).offset(20)
            make.height.equalTo(32)
            make.top.equalToSuperview().offset(168)
            make.leading.equalToSuperview().offset(20)
        }

        categoryLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.lessThanOrEqualToSuperview().offset(-20)
        }

        headlineLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(216)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        authorLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(296)
            make.leading.equalToSuperview().offset(26)
            make.trailing.equalToSuperview().offset(-20)
        }

        authorGreyLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(320)
            make.leading.equalToSuperview().offset(26)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentImage.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview()
        }
    }

}
