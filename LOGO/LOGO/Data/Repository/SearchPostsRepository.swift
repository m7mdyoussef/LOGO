

import Foundation
import Combine

protocol SearchPostsRepositoryProtocol {
    func data(text: String) -> AnyPublisher<Posts?, APIError>
}

final class SearchPostsRepository {

    private let service: SearchPostsDataRemoteProtocol

    init(service: SearchPostsDataRemoteProtocol = DIContainer.shared.inject(type: SearchPostsDataRemoteProtocol.self)!) {
        self.service = service
    }
}

extension SearchPostsRepository: SearchPostsRepositoryProtocol {
    func data(text: String) -> AnyPublisher<Posts?, APIError> {
        return self.service.fetch(text: text)
    }
}
