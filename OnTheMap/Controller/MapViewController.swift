import UIKit
import MapKit

class MapViewController: UIViewController {

    var repository: StudentsRepository!

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
        mapView.delegate = self

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

            print("adicionado ao mapa com sucesso")
        }
    }
}

extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: "pin")
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
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

        guard let url = URL(string: subtitle) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)

        } else {
            //TODO: Handle error if there is an invalid url
        }
    }
}
