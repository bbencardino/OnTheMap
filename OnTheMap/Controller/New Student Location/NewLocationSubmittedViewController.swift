import UIKit
import MapKit
import CoreLocation

class NewLocationSubmittedViewController: UIViewController {

    var repository: StudentsRepository!

    private let textFieldDelegate = TextFieldDelegate()
    private var studentLocation: StudentLocation!
    var mapString: String!
    var coordinate: CLLocationCoordinate2D!

    @IBOutlet weak var spin: UIActivityIndicatorView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mediaTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        convertMapString()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mediaTextField.text = "Enter a Link to share here"
        mediaTextField.delegate = textFieldDelegate
    }

    @IBAction func submitNewLocation(_ sender: Any) {
        var media = mediaTextField.text ?? ""
        if media == "Enter a Link to share here" {
            media = ""
        }
        let latitude = Double(coordinate.latitude)
        let longitude = Double(coordinate.longitude)

        UdacityClient.addStudentLocation(mapString: mapString, mediaURL: media, latitude: latitude, longitude: longitude, completionHandler: { success, error in

            if success {
                self.repository.getStudents { _ in }
                Alert.actionAlert(title: "Success", message: "A student was added successfully", vc: self) { _ in

                    //dismiss to the root
                    self.presentingViewController?.presentingViewController?.dismiss(animated: false)
                }
            } else {
                Alert.basicAlert(title: "Weird", message: error?.localizedDescription ?? "", vc: self)
            }
        })
    }
    
    @IBAction func cancelNewLocation(_ sender: Any) {
        dismiss(animated: true)
    }

    // MARK: - Map View

    private func convertMapString() {
        spin.startAnimating()
        let geoCoder = CLGeocoder()

        geoCoder.geocodeAddressString(mapString, completionHandler: handleAddressStringResponse(placemarks:error:))
    }

    private func handleAddressStringResponse(placemarks: [CLPlacemark]?, error: Error?) {

        if error != nil {
            Alert.dismissAlert(title: "Invalid city or country", message: "Please enter a valid city or country", vc: self)
            spin.stopAnimating()
        } else {
            spin.stopAnimating()
            var location: CLLocation?
            if let placemarks = placemarks, placemarks.count > 0 {
                location = placemarks.first?.location
            }

            if let location = location {
                let coordinate = location.coordinate
                self.coordinate = coordinate
                let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
                mapView.setRegion(region, animated: true)

                let pin = MKPointAnnotation()
                pin.coordinate = coordinate
                mapView.addAnnotation(pin)

            } else {
                Alert.basicAlert(title: "Location Not Found", message: "Please enter correct location", vc: self)
            }
        }
    }
}
