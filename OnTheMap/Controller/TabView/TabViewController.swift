import UIKit

final class TabViewController: UITabBarController {

    var repository: StudentsRepository!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        repository.getStudents { error  in
            if let error = error {
                Alert.basicAlert(title: "Download Failed", message: error.localizedDescription, vc: self)
            } else {
                self.setUpChildViewController()
            }
        }
    }

    private func setUpChildViewController() {
        guard let viewControllers = viewControllers else { return }
        for viewController in viewControllers {
            switch viewController {
            case let viewController as ListViewController:
                viewController.repository = self.repository
            case let viewController as MapViewController:
                viewController.repository = self.repository
            default:
                break
            }
        }
    }
}
