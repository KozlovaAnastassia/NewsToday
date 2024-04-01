import UIKit
import SnapKit

class ViewController: UIViewController {
    
    let userDefaultsManager = UserDefaultsManager()
    // MARK: - UI Elements
    let label = UILabel.makeLabel(text: "Hello, world!",
                                  font: UIFont.InterBold(ofSize: 20),
                                  textColor: .blackLight,
                                  numberOfLines: nil)
    
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .purpleLight
        layout()
        //        topHeadlinesTest()
        //        search()
        loadAndFetchCategories()
        
    }
    
    /// Отправляет запрос к API для получения данных и обрабатывает результаты.
    private func search() {
        NetworkManager.shared.fetchData(for: "Apple") { result in
            switch result {
            case .success(let search):
                print("Results: \(search)")
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    private func topHeadlinesTest() { NetworkManager.shared.fetchTopHeadlines(category: "technology") { result in
        switch result {
        case .success(let category):
            print("Results: \(category)")
        case .failure(let error):
            print("Error: \(error)")
        }
    }
    }
    
    func loadAndFetchCategories() {
        // Извлекаем сохранённые категории из UserDefaults
        if let savedCategories = userDefaultsManager.getStringArray(forKey: .selectedCategories) {
            // Передаём сохранённые категории в метод fetchCategories
            NetworkManager.shared.fetchCategories(for: savedCategories) { categoryName, result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let searchResults):
                        print("Results for \(categoryName):", searchResults)
                    case .failure(let error):
                        print("Error fetching data for \(categoryName):", error)
                    }
                }
            }
        }
    }
        //MARK: Private Methods
        private func layout() {
            view.addSubview(label)
            
            label.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview()
            }
        }
    }

