import Foundation

class StudentsRepository {
    
    var students: [StudentLocation] = []

    func getStudents(completion: @escaping () -> ()) {
        UdacityClient.getStudentLocation { students, error in
            self.students = students
            completion()
        }
    }
}
