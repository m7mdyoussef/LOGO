
import Foundation
import Combine
@testable import LOGO

final class SignInRemoteMock: SignInRemoteProtocol {
    var fetchedResult: AnyPublisher <LOGO.User?, APIError>!
    func fetch(userName:String,
               password: String) -> AnyPublisher<LOGO.User?, APIError>{
        return fetchedResult
    }
}
