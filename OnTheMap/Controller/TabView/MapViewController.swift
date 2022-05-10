import UIKit
import MapKit

final class MapViewController: UIViewController {

    var repository: StudentsRepository?

    @IBOutlet weak var mapView: MKMapView!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        annotations.isEmpty ? configureMapView() : removeAllPins()
        addAllPins()
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

    @IBAction func addStudent(_ sender: UIBarButtonItem) {
        if let repository = repository {

            //if there's internet, check if student has already been posted
            repository.students.forEach { student in
                if student.uniqueKey == UdacityClient.Auth.uniqueKey {
                    Alert.overwriteAlert(title: "", message: "You have already posted a student location. Would you like to overwrite your current location?", vc: self) { _ in
                      self.performSegue(withIdentifier: "newLocationFromMap", sender: nil)
                    }
                } else {
                    self.performSegue(withIdentifier: "newLocationFromMap", sender: nil)
                }
            }
        } else {
            Alert.dismissAlert(title: "Bad internet connection", message: "It's not possible to add a new student. Please connect to a better internet", vc: self)
        }
    }
    //MARK: - Map View

    private var annotations = [MKAnnotation]()

    @IBAction func refresh(_ sender: Any) {
        repository?.getStudents(completion: { _ in })
        annotations.isEmpty ? configureMapView() : removeAllPins()
        addAllPins()
    }

    private func configureMapView() {
        mapView.delegate = self
        if let repository = repository {

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

            }
        } else {
            Alert.basicAlert(title: "Download Failed", message: "It's not possible to download students. Please connect to a better internet", vc: self)
        }
    }
    // MARK: - Helper methods

    private func addAllPins() {
        mapView.addAnnotations(annotations)
    }

    private func removeAllPins() {
        mapView.removeAnnotations(annotations)
    }
}

extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: "pin")
        if pinView == nil {
            pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            pinView?.tintColor = .systemMint
            pinView?.canShowCallout = true
            pinView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView?.annotation = annotation
        }
        return pinView
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {

        let subtitle = view.annotation?.subtitle! ?? ""

        guard let url = URL(string: subtitle) else {
            Alert.basicAlert(title: "Empty URL", message: "This student shared an empty URL", vc: self)
            return
        }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)

        } else {
            Alert.basicAlert(title: "Invalid URL", message: "This student shared an invalid URL", vc: self)
        }
    }
}
