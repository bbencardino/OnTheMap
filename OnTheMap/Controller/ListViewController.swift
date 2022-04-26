import UIKit

class ListViewController: UITableViewController {

    var repository: StudentsRepository!

    override func viewDidLoad() {
        super.viewDidLoad()

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
    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        repository.students.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath)

        let student = repository.students[indexPath.row]
        cell.textLabel?.text = (student.firstName) + " " + (student.lastName)
        cell.detailTextLabel?.text = student.mapString

        return cell
    }


}
