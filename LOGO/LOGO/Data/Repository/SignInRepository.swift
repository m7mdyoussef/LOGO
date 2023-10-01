
import Foundation
import Combine

protocol SignInRepositoryProrocol {
    func data(userName: String,
              password: String) -> AnyPublisher<User?, APIError>
}

final class SignInRepository {

    private let service: SignInRemoteProtocol

    init(service: SignInRemoteProtocol = DIContainer.shared.inject(type: SignInRemoteProtocol.self)!) {
        self.service = service
    }
}

extension SignInRepository: SignInRepositoryProrocol {
    func data(userName: String,
              password: String) -> AnyPublisher<User?, APIError> {
        return self.service.fetch(userName: userName,
                                  password: password)
    }
}
