import UIKit
import MapKit
import CoreLocation

class NewLocationSubmittedViewController: UIViewController {

    var repository: StudentsRepository!

    private let textFieldDelegate = TextFieldDelegate()
    private var studentLocation: StudentLocation!
    var mapString: String!
    var coordinate: CLLocationCoordinate2D!

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mediaTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureMapView()
        mediaTextField.text = ""
        mediaTextField.delegate = textFieldDelegate
    }
    
    @IBAction func submitNewLocation(_ sender: Any) {

        let media = mediaTextField.text ?? ""
        let latitude = Double(coordinate.latitude)
        let longitude = Double(coordinate.longitude)

        let student = UdacityClient.addStudentLocation(mapString: mapString, mediaURL: media, latitude: latitude, longitude: longitude, completionHandler: { success, error in

        })
            self.repository.students.append(student)

    }
    
    @IBAction func cancelNewLocation(_ sender: Any) {
        dismiss(animated: true)
    }



// MARK: - Map View

    private func configureMapView() {

        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(mapString) { placemark, error in
            self.handleAddressStringResponse(placemarks: placemark, error: error)
        }
    }

    private func handleAddressStringResponse(placemarks: [CLPlacemark]?, error: Error?) {

        if error != nil {
            //TODO: Handle error when location is not found

        } else {
            var location: CLLocation?
            if let placemarks = placemarks, placemarks.count > 0 {
                location = placemarks.first?.location
            }

            if let location = location {
                let coordinate = location.coordinate
                self.coordinate = coordinate
                print(coordinate)
            } else {
                //TODO: Handle error when location is not found
            }
        }
    }
}


