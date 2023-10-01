
import Foundation
import Combine
@testable import LOGO

final class PostsRepositoryMock: PostsRepositoryProrocol {
    let mockPostsService = PostsRemoteMock()
    func data(limit: Int,
              skip: Int) -> AnyPublisher<LOGO.Posts?, LOGO.APIError> {
         return mockPostsService.fetchedResult
    }
}
