

import Foundation
import Combine
@testable import LOGO

class MockSearchPostsRepository: SearchPostsRepositoryProtocol {
    let mockSearchPostsRemote = MockSearchPostsRemote()
    func data(text: String) -> AnyPublisher<LOGO.Posts?, LOGO.APIError> {
        return mockSearchPostsRemote.fetchedResult
    }
}
