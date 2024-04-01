import UIKit
import SnapKit


protocol HomeViewControllerProtocol: AnyObject {
    func reloadCollectionView(section: Int)
}

final class HomeViewController: UIViewController {

    //MARK: - Presenter
    var presenter: HomePresenterProtocol!
    var isTapped = false
    var isFirstEnter = true
    var selectedCategoryIndex: Int? = nil

    //MARK: -> Properties
    private lazy var collectionView: UICollectionView = {
        let layout = self.createLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()

    private let titleLabel = UILabel.makeLabel(text: Constants.homeTitle,
                                               font: UIFont.InterBold(ofSize: 24),
                                               textColor: UIColor.blackPrimary,
                                               numberOfLines: .zero)
    

    //MARK: -> Life circle
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        collectionViewRegister()
        view.hideKeyboard()
        if isFirstEnter {
            let firstCategory = presenter.getCategory(at: IndexPath(row: 0, section: 0)) // Получаем первую категорию
            selectedCategoryIndex = 0 // Устанавливаем индекс выбранной категории
            isFirstEnter = false // Устанавливаем флаг в false, чтобы избежать повторной загрузки при последующих отображениях экрана
            presenter.topHeadlinesTest(category: firstCategory) // Вызываем метод загрузки данных для первой категории
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.loadAndFetchCategories()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isFirstEnter = false
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        presenter.clearRecommended()
    }

    //MARK: -> Functions
    private func setViews() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        let item = UIBarButtonItem(customView: titleLabel)
        navigationItem.leftBarButtonItem = item
    }

    private func collectionViewRegister() {
        collectionView.register(CategoriesCustomCell.self, forCellWithReuseIdentifier: CategoriesCustomCell.reuseIdentifier)
        collectionView.register(PopularCustomCell.self, forCellWithReuseIdentifier: PopularCustomCell.reuseIdentifier)
        collectionView.register(RecommendedCustomCell.self, forCellWithReuseIdentifier: RecommendedCustomCell.reuseIdentifier)
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CustomHeaderView.reuseIdentifier)
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: RecommendedCustomHeader.reuseIdentifier)
    }

    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
        guard let sectionKind = Section(rawValue: sectionIndex) else { return nil }

            let section = self.createSection(sectionKind: sectionKind)
            return section
        }
        return layout
    }

    private func createItem() -> NSCollectionLayoutItem {
        let itemSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 2, leading: 2, bottom: 2, trailing: 10)
        return item
    }

    private func createGroup(sectionKind: Section) -> NSCollectionLayoutGroup {

        let columns = sectionKind.columnCount
        let item = createItem()

        var groupHeight = NSCollectionLayoutDimension.fractionalWidth(1.0)
        var groupWidth = NSCollectionLayoutDimension.fractionalWidth(1.0)

        switch columns {
        case 4: groupHeight = NSCollectionLayoutDimension.absolute(40)
        case 2: groupHeight = NSCollectionLayoutDimension.absolute(250)
                groupWidth = NSCollectionLayoutDimension.absolute(500)
        default: groupHeight = NSCollectionLayoutDimension.absolute(100)
        }

        let groupSize = NSCollectionLayoutSize(
        widthDimension: groupWidth,
        heightDimension: groupHeight)

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columns)
        return group
    }

    private func createSection(sectionKind: Section) -> NSCollectionLayoutSection {
        let group = self.createGroup(sectionKind: sectionKind)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 20, leading: 16, bottom: 10, trailing: 16)

        if sectionKind == .categories {
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(110))
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            section.boundarySupplementaryItems = [header]

        } else if sectionKind == .recommended {
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(60))
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            section.boundarySupplementaryItems = [header]
        }

        if sectionKind == .categories || sectionKind == .popular {
            section.orthogonalScrollingBehavior = .continuous
        }
        return section
    }
    

}
//MARK: -> Extension
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        Section.allCases.count
      }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:  return presenter.getCategoryArrayCount()
        case 1:  return presenter.getArticleArrayCount()
        default: return presenter.getRecommendedArrayCount()
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if kind == UICollectionView.elementKindSectionHeader {
                  if indexPath.section == 0 {
                      let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CustomHeaderView.reuseIdentifier, for: indexPath)
                      let customHeaderView = CustomHeaderView(frame: headerView.bounds)
                      customHeaderView.delegate = self
                      headerView.addSubview(customHeaderView)
                      return headerView
                  } else if indexPath.section == 2 {
                      let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: RecommendedCustomHeader.reuseIdentifier, for: indexPath)
                      let customHeaderView = RecommendedCustomHeader(frame: headerView.bounds)
                      customHeaderView.configure(handler: presenter.showSeeAllVC)
                      headerView.addSubview(customHeaderView)
                      return headerView
                  }
              }
              return UICollectionReusableView()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesCustomCell.reuseIdentifier, for: indexPath) as! CategoriesCustomCell
            let titleCategory = presenter.getCategory(at: indexPath)
            let isSelected = indexPath.row == selectedCategoryIndex
            cell.configure(titleCategory: titleCategory, isSelected: isSelected) { [weak self] in
                guard let self = self else { return }
                
                if let selectedCategoryIndex = self.selectedCategoryIndex, selectedCategoryIndex != indexPath.row {
                    let previousIndexPath = IndexPath(row: selectedCategoryIndex, section: 0)
                    self.selectedCategoryIndex = indexPath.row
                    self.collectionView.reloadItems(at: [previousIndexPath, indexPath])
                } else {
                    self.selectedCategoryIndex = indexPath.row
                }
                self.presenter.topHeadlinesTest(category: titleCategory)
                collectionView.reloadData()
                collectionView.scrollToItem(at: IndexPath(item: 0, section: 1), at: .left, animated: true)
            }
            return cell

        case 1:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PopularCustomCell.reuseIdentifier,
                for: indexPath) as? PopularCustomCell else {
                return UICollectionViewCell()
            }
            let data = presenter.getArticle(at: indexPath.row)
            cell.configure(imageURL: data.urlToImage ?? "",
                           title: data.author ?? "",
                           text:data.title ?? "",
                           id: String(indexPath.row),
                           handler: { [weak self] in
                self?.presenter.showDetailsVC(data: data, tag: String(indexPath.row))
                            })
            
            return cell

        default:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RecommendedCustomCell.reuseIdentifier,
                for: indexPath) as? RecommendedCustomCell else {
                return UICollectionViewCell()
            }
            
            let data = presenter.getRecommended(at: indexPath)
            cell.configure(model: RecommendedModel(imageURL: data.articles[indexPath.row].urlToImage ?? "", 
                                                   categoryName: data.articles[indexPath.row].publishedAt ?? "",
                                                   titleText: data.articles[indexPath.row].title ?? "",
                                                   id: String(indexPath.row)
                                                  )
            )
            return cell
        }
    }
}

extension HomeViewController: HomeViewControllerProtocol {
    func reloadCollectionView(section: Int) {
        self.collectionView.reloadSections(IndexSet(integer: section))
    }
    
}

extension HomeViewController: CustomHeaderViewDelegate {
    
    func searchBarTextDidChange(_ searchBar: UISearchBar, newText: String) {
    }

    func searchBarSearchButtonClicked(with text: String) {

        guard let homePresenter = presenter as? HomePresenter else { return }

        NetworkManager.shared.fetchData(for: text) { result in
            switch result {
            case .success(let articles):
                DispatchQueue.main.async {
                    self.presenter.articles = articles.articles
                    let searchVC = SearchArticlesViewController(searchText: text)
                    searchVC.articles = articles.articles
//                    self.presenter.router?.showSearchVC(searchText: text)
                    self.navigationController?.pushViewController(searchVC, animated: true)
                }

            case .failure(let error):
                print(error)
            }
        }
    }
}
