
import Foundation

struct User: Codable {
    let id: Int?
    let username, email, firstName, lastName: String?
    let gender: String?
    let image: String?
    let token: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case username = "username"
        case email = "email"
        case firstName = "firstName"
        case lastName = "lastName"
        case gender = "gender"
        case image = "image"
        case token = "token"
    }
}

extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}
