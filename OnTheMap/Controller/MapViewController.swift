import UIKit

class MapViewController: UIViewController {

    var repository: StudentsRepository!

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! NewLocationViewController
        if segue.identifier == "newLocationFromMap" {
            destinationVC.repository = self.repository
        }
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {

        UdacityClient.logout {
            self.dismiss(animated: true)
        }
    }
    
}
