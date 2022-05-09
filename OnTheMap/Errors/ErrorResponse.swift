import Foundation

struct ErrorResponse: Codable, Error {

    let statusCode: Int
    let statusMessage: String

    enum CodingKeys: String, CodingKey {
        case statusCode = "status"
        case statusMessage = "error"
    }
}

extension ErrorResponse: LocalizedError {
    var errorDescription: String? {
        switch statusCode  {
        case 400:
            return NSLocalizedString("Email or/and password empty, please fill with the appropriate information", comment: "")
        case 403:
            return NSLocalizedString("The credentials were incorrect, please check your email or/and your password", comment: "")
        default:
            return NSLocalizedString("You are not able to login :( \(statusCode)", comment: "")
        }
    }
}
