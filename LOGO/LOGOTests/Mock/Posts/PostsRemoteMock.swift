

import Foundation
import Combine
@testable import LOGO

final class PostsRemoteMock: PostsRemoteProtocol {
    var fetchedResult: AnyPublisher <LOGO.Posts?, APIError>!
    func fetch(limit: Int, skip: Int) -> AnyPublisher<LOGO.Posts?, LOGO.APIError> {
        return fetchedResult
    }
}
