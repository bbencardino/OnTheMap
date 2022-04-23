import UIKit

class MapViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func logoutButtonTapped(_ sender: Any) {

        UdacityClient.logout {
            self.dismiss(animated: true)
        }
    }
    
}
