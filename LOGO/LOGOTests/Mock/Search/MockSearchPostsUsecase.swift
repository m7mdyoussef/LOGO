
import Foundation
import Combine
@testable import LOGO

class MockSearchPostsUsecase: SearchPostUsecaseProtocol {
    let mockSearchPostsRepository = MockSearchPostsRepository()
    func execute(text: String) -> AnyPublisher<LOGO.Posts?, LOGO.APIError> {
        return mockSearchPostsRepository.data(text: text)
    }
}
