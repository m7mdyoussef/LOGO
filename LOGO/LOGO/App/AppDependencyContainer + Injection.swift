
import Foundation

extension DIContainer {
    func registration() {

       // SignIn
        register(type: SignInRemoteProtocol.self, component: SignInRemote())
        register(type: SignInRepositoryProrocol.self, component: SignInRepository())
        register(type: CoreDataManagerProtocol.self, component: CoreDataManager())
        register(type: SignInUsecaseProtocol.self, component: SignInUsecase())

        // Home
         register(type: PostsRemoteProtocol.self, component: PostsRemote())
         register(type: PostsRepositoryProrocol.self, component: PostsRepository())
         register(type: CoreDataManagerProtocol.self, component: CoreDataManager())
         register(type: PostsCasheRepositoryProtocol.self, component: PostsCacheRepository())
         register(type: PostUsecaseProtocol.self, component: PostUsecase())
        
    }
}
