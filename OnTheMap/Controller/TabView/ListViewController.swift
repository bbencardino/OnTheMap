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
        cell.detailTextLabel?.text = student.mediaURL

        return cell
    }
    //MARK: - Table View Delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let student = repository.students[indexPath.row]
        guard let url = URL(string: student.mediaURL) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            //TODO: Handle error when the url is not valid 
        }
    }
}
