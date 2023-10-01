
import Foundation
import Combine

protocol PostUsecaseProtocol: AnyObject {
    func execute(limit: Int,
                 skip: Int) -> AnyPublisher<Posts?, APIError>
}

final class PostUsecase: PostUsecaseProtocol {

    private let postsRepository: PostsRepositoryProrocol
    private let persistance: PostsCasheRepositoryProtocol
    var subscriber = Cancelable()

    init(postsPriceRepository: PostsRepositoryProrocol = DIContainer.shared.inject(type: PostsRepositoryProrocol.self)!,
         persistance: PostsCasheRepositoryProtocol = DIContainer.shared.inject(type: PostsCasheRepositoryProtocol.self)!) {
        self.postsRepository = postsPriceRepository
        self.persistance = persistance
    }

    func execute(limit: Int,
                 skip: Int) -> AnyPublisher<Posts?, APIError> {
        
        return self.postsRepository.data(limit: limit,
                                         skip: skip)
        
    }
}
