
import Foundation
import Combine

protocol SignInUsecaseProtocol: AnyObject {
    func execute(userName: String,
                 password: String) -> AnyPublisher<User?, APIError>
}

final class SignInUsecase: SignInUsecaseProtocol {
    
    private let signInRepository: SignInRepositoryProrocol
    
    var subscriber = Cancelable()

    init(signInRepository: SignInRepositoryProrocol = DIContainer.shared.inject(type: SignInRepositoryProrocol.self)!) {
        self.signInRepository = signInRepository
    }

    func execute(userName: String,
                 password: String) -> AnyPublisher<User?, APIError> {
            self.signInRepository.data(userName: userName,
                                       password: password)
    }
}
