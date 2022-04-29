import UIKit

final class Alert {

    class func basicAlert(title: String, message: String, vc: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        vc.present(alert, animated: true)
    }

    class func dismissAlert(title: String, message: String, vc: UIViewController) {

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Back", style: .default, handler: { _ in
            vc.dismiss(animated: true)
        }))

        vc.present(alert, animated: true)
    }
    class func actionAlert(title: String,
                           message: String,
                           vc: UIViewController,
                           handler: @escaping (UIAlertAction) -> Void) {

        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default,
                                      handler: handler))
        vc.present(alert, animated: true)
    }

    class func overwriteAlert(title: String,
                              message: String,
                              vc: UIViewController,
                              overwrite: @escaping (UIAlertAction) -> Void) {
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Overwrite",
                                      style: .default,
                                      handler: overwrite))
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: .cancel))
        vc.present(alert, animated: true)
    }
}
