
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

extension User {
    // make image url safe
    func safeImageURL() -> String {
        guard let url = self.image else {return .empty}
        let safeURL = url.trimmingString()
        return safeURL
    }
}

extension User {
    static let mockUser = User.init(id: 15,
                                    username: "joe",
                                    email: "joe@m.com",
                                    firstName: "mohamed",
                                    lastName: "youssef",
                                    gender: "male",
                                    image: "https://robohash.org/autquiaut.png",
                                    token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTUsInVzZXJuYW1lIjoia21pbmNoZWxsZSIsImVtYWlsIjoia21pbmNoZWxsZUBxcS5jb20iLCJmaXJzdE5hbWUiOiJKZWFubmUiLCJsYXN0TmFtZSI6IkhhbHZvcnNvbiIsImdlbmRlciI6ImZlbWFsZSIsImltYWdlIjoiaHR0cHM6Ly9yb2JvaGFzaC5vcmcvYXV0cXVpYXV0LnBuZyIsImlhdCI6MTY5NjE2MzU1NiwiZXhwIjoxNjk2MTY3MTU2fQ.UnFV4ucy3xwQN0tJmVXN7QMaDjpk465C7eht9QsR3dg")
    
}
