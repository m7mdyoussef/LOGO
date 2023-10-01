
import Foundation
import Combine

protocol SignInRemoteProtocol: AnyObject {
     func fetch(userName:String,
                password: String) -> AnyPublisher<User?, APIError>
}

final class SignInRemote: NetworkClientManager<HttpRequest>, SignInRemoteProtocol {
    func fetch(userName: String,
               password: String) -> AnyPublisher<User?, APIError> {
        self.request(request: HttpRequest(request: SignInRequest(userName: userName,
                                                                 password: password)),
                     scheduler: WorkScheduler.mainScheduler,
                     responseObject: User?.self)
    }
}

struct SignInRequest: NetworkTarget {    

    let userName: String
    let password: String

    init(userName: String,
         password: String
         ) {
        self.password = password
        self.userName = userName
    }

    var baseURL: BaseURLType {
        return .baseApi
    }

    var path: String? {
        return "/auth/login"
    }

    var methodType: HTTPMethod {
        .post
    }
    
    var parameters: [String : Any]? {
        return ["username": userName,
                "password": password]
    }
    
    var bodyEncoding: BodyEncoding?{
        return .xWWWFormURLEncoded
    }
    
    var headers: [String: String]? {
        ["Content-Type": "application/x-www-form-urlencoded"]
    }
}
