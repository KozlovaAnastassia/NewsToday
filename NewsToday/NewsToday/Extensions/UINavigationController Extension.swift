import UIKit

extension UINavigationController {
    func configureTabBarItem(_ image: String) {
        self.tabBarItem.image = UIImage(named: image)

//        self.tabBarItem.selectedImage = UIImage(named: selectedImage)

        //перенести в другое место для разделения ответственности?
        self.view.backgroundColor = .white
    }
}
