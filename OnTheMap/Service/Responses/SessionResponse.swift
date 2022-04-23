import Foundation

struct SessionResponse: Decodable {
    let registered: Bool
    let key: String
    let id: String
    let expiration: String

    enum CodingKeys: String, CodingKey {
        case account
        case session
    }

    enum SessionCodingKeys: String, CodingKey {
        case id
        case expiration
    }

    enum AccountCodingKeys: String, CodingKey {
        case registered
        case key
    }

    init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)
        let sessionCoding = try container.nestedContainer(keyedBy: SessionCodingKeys.self,
                                                         forKey: .session)
        id = try sessionCoding.decode(String.self, forKey: .id)
        expiration = try sessionCoding.decode(String.self, forKey: .expiration)

        let accountCoding = try container.nestedContainer(keyedBy: AccountCodingKeys.self,
                                                          forKey: .account)
        key = try accountCoding.decode(String.self, forKey: .key)
        registered = try accountCoding.decode(Bool.self, forKey: .registered)
    }
}
