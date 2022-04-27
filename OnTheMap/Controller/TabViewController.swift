import UIKit

class TabViewController: UITabBarController {

    var repository: StudentsRepository?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UdacityClient.getStudentLocation { students, error in
            self.repository?.students = students
            self.setUpChildViewController()
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
