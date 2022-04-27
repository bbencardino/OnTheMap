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

        addStudents()

    }
    
    @IBAction func cancelNewLocation(_ sender: Any) {
        dismiss(animated: true)
    }

    private func addStudents() {
        let media = mediaTextField.text ?? ""
        let latitude = Double(coordinate.latitude)
        let longitude = Double(coordinate.longitude)

        let student = UdacityClient.addStudentLocation(mapString: mapString, mediaURL: media, latitude: latitude, longitude: longitude, completionHandler: { success, error in
        })

        repository.students.append(student)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TabViewController
        if segue.identifier == "SubmittedPin" {
            destinationVC.repository = self.repository
        }
    }

// MARK: - Map View

    private func convertMapString() {
        spin.startAnimating()
        let geoCoder = CLGeocoder()

        geoCoder.geocodeAddressString(mapString, completionHandler: handleAddressStringResponse(placemarks:error:))
    }

    private func handleAddressStringResponse(placemarks: [CLPlacemark]?, error: Error?) {

        if let error = error {
            print(error)
           //TODO: Handle error when the location is incorrect

        } else {
            spin.stopAnimating()
            var location: CLLocation?
            if let placemarks = placemarks, placemarks.count > 0 {
                location = placemarks.first?.location
            }

            if let location = location {
                let coordinate = location.coordinate
                self.coordinate = coordinate
                
                print(coordinate)
                mapView.region.center = coordinate

            } else {
                //TODO: Handle error when location is not found
            }
        }
    }
}


