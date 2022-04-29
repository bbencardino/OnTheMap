import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var spin: UIActivityIndicatorView!

    let textFieldDelegate = TextFieldDelegate()
    let repository = StudentsRepository()

    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.delegate = textFieldDelegate
        passwordTextField.delegate = textFieldDelegate

        emailTextField.text = ""
        passwordTextField.text = ""
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TabViewController
        if segue.identifier == "completedLogin" {
            destinationVC.repository = self.repository
        }
    }

    @IBAction func loginButtonTapped(_ sender: UIButton) {
        startLogin(true)
        let username = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let udacity = [username:password]

        UdacityClient.login(username: username, password: password, udacity: udacity) { success, error in

            if success {
                self.startLogin(false)
                self.performSegue(withIdentifier: "completedLogin", sender: nil)
            } else {
                DispatchQueue.main.async {
                    Alert.basicAlert(title: "Login Failed", message: error?.localizedDescription ?? "", vc: self)
                    self.startLogin(false)
                }
            }
        }
    }

    @IBAction func loginWithFacebook(_ sender: UIButton) {}

    private func startLogin(_ login: Bool) {
        login ? spin.startAnimating() : spin.stopAnimating()
    }
}
