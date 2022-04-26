import UIKit

class NewLocationSubmittedViewController: UIViewController {

    var repository: StudentsRepository!

    private let textFieldDelegate = TextFieldDelegate()
    private var studentLocation: StudentLocation!
    var location = "London, UK"

    @IBOutlet weak var mediaTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        mediaTextField.text = ""
        mediaTextField.delegate = textFieldDelegate
    }
    
    @IBAction func submitNewLocation(_ sender: Any) {

        let media = mediaTextField.text ?? ""

        let student = UdacityClient.addStudentLocation(mapString: location, mediaURL: media, completionHandler: { success, error in
        })

        repository.students.append(student)
        dismiss(animated: true)
    }
    
    @IBAction func cancelNewLocation(_ sender: Any) {
        dismiss(animated: true)
    }
    
}
