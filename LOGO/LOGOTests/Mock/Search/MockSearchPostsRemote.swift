

import Foundation
import Combine
@testable import LOGO

class MockSearchPostsRemote: SearchPostsDataRemoteProtocol {
    var fetchedResult : AnyPublisher <LOGO.Posts?, APIError>!
    func fetch(text: String) -> AnyPublisher<LOGO.Posts?, LOGO.APIError> {
        return fetchedResult
    }
}
