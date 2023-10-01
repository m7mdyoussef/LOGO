
import Foundation
import Combine
@testable import LOGO

final class PostsUseCaseMock: PostUsecaseProtocol {
    let mockPostsRepisitory = PostsRepositoryMock()
    func execute(limit: Int,
                 skip: Int) -> AnyPublisher<LOGO.Posts?, LOGO.APIError> {
        return mockPostsRepisitory.data(limit: limit, skip: skip)
    }
}
