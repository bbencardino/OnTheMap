import Foundation

class StudentsRepository {
    
    var students: [StudentLocation] = []

    func getStudents(completion: @escaping (Error?) -> ()) {
        UdacityClient.getStudentLocation { students, error in
            self.students = students
            completion(error)
        }
    }
}
