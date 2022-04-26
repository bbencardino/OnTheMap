import Foundation

struct StudentLocation: Codable {

    let uniqueKey, mediaURL: String
    var firstName, lastName: String
    var mapString: String
    let latitude, longitude: Double
}

