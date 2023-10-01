
import Foundation

extension DIContainer {
    func registration() {

       // SignIn
        register(type: SignInRemoteProtocol.self, component: SignInRemote())
        register(type: SignInRepositoryProrocol.self, component: SignInRepository())
        register(type: CoreDataManagerProtocol.self, component: CoreDataManager())
        register(type: SignInUsecaseProtocol.self, component: SignInUsecase())

    }
}
