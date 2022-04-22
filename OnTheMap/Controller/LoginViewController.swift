import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    let textFieldDelegate = TextFieldDelegate()

    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.delegate = textFieldDelegate
        passwordTextField.delegate = textFieldDelegate
    }

    @IBAction func loginButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "completedLogin", sender: self)
    }

    @IBAction func loginWithFacebook(_ sender: UIButton) {}
}

