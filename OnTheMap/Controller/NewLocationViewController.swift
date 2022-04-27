import UIKit

class NewLocationViewController: UIViewController {

    let textFieldDelegate = TextFieldDelegate()
    var repository: StudentsRepository!

    @IBOutlet weak var locationTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        locationTextField.text = ""
        locationTextField.delegate = textFieldDelegate
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let location = locationTextField.text ?? ""
        let destinationVC = segue.destination as! NewLocationSubmittedViewController
        if segue.identifier == "findLocation" {
            destinationVC.mapString = location
            destinationVC.repository = self.repository
        }
    }

    @IBAction func cancelNewLocation(_ sender: Any) {
        dismiss(animated: true)
    }


    @IBAction func findLocation(_ sender: Any) {

    }



}
