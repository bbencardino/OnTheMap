import Foundation

struct ErrorResponse: Codable {

    let statusCode: Int
    let statusMessage: String

    enum CodingKeys: String, CodingKey {
        case statusCode = "status"
        case statusMessage = "error"
    }
}

extension ErrorResponse: LocalizedError {
    var errorDescription: String? {
        return statusMessage
    }
}
