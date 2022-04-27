import UIKit
import MapKit

class MapViewController: UIViewController {

    var repository: StudentsRepository!
    private let mapViewDelegate = MapViewDelegate()

    @IBOutlet weak var mapView: MKMapView!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureMapView()
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

    //MARK: - Map View

    var annotations = [MKPointAnnotation]()

    private func configureMapView() {

        for student in repository.students {
            let latitude = CLLocationDegrees(student.latitude)
            let longitude = CLLocationDegrees(student.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

            let firstName = student.firstName
            let lastName = student.lastName
            let media = student.mediaURL

            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(firstName) \(lastName)"
            annotation.subtitle = media

            annotations.append(annotation)
            mapView.addAnnotations(annotations)
            mapView.delegate = mapViewDelegate
        }
    }
}
