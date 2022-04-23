import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    let textFieldDelegate = TextFieldDelegate()

    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.delegate = textFieldDelegate
        passwordTextField.delegate = textFieldDelegate

        emailTextField.text = ""
        passwordTextField.text = ""
    }

    @IBAction func loginButtonTapped(_ sender: UIButton) {
        let username = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let udacity = [username:password]

        UdacityClient.login(username: username, password: password, udacity: udacity) { success, error in
            success ? self.performSegue(withIdentifier: "completedLogin", sender: nil) : print(error)

        }
    }

    @IBAction func loginWithFacebook(_ sender: UIButton) {}


}

