import UIKit

class ListViewController: UITableViewController {

    private var viewModel = StudentsModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.reloadData()

        UdacityClient.getStudentLocation { students, error in

            self.viewModel.students = students
            self.tableView.reloadData()
        }
    }

    @IBAction func logoutButtonTapped(_ sender: Any) {

        UdacityClient.logout {
            self.dismiss(animated: true)
        }
    }
    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        viewModel.students.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath)

        let student = viewModel.students[indexPath.row]
        cell.textLabel?.text = (student.firstName) + " " + (student.lastName)

        return cell
    }


}
