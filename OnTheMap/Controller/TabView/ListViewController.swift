import UIKit

class ListViewController: UITableViewController {

    var repository: StudentsRepository!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        tableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! NewLocationViewController
        if segue.identifier == "newLocationFromList" {
            destinationVC.repository = self.repository
        }
    }

    @IBAction func logoutButtonTapped(_ sender: Any) {
        UdacityClient.logout {
            self.dismiss(animated: true)
        }
    }
    
    @IBAction func addStudent(_ sender: UIBarButtonItem) {

        repository.students.forEach { student in

            if student.uniqueKey == UdacityClient.Auth.uniqueKey {
                Alert.overwriteAlert(title: "", message: "You have already posted a student location. Would you like to overwrite your current location?", vc: self) { _ in
                  self.performSegue(withIdentifier: "newLocationFromList", sender: nil)
                }
            } else {
                self.performSegue(withIdentifier: "newLocationFromList", sender: nil)
            }
        }
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        repository.students.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath)

        let student = repository.students[indexPath.row]
        cell.textLabel?.text = (student.firstName) + " " + (student.lastName)
        cell.detailTextLabel?.text = student.mediaURL

        return cell
    }
    //MARK: - Table View Delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let student = repository.students[indexPath.row]
        guard let url = URL(string: student.mediaURL) else {
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
