
import Foundation
import Combine

protocol SearchPostsDataRemoteProtocol: AnyObject {
    func fetch(text: String) -> AnyPublisher<Posts?, APIError>
}

final class SearchPostsDataRemote: NetworkClientManager<HttpRequest>, SearchPostsDataRemoteProtocol {
    func fetch(text: String) -> AnyPublisher<Posts?, APIError> {
        self.request(request: HttpRequest(request: SearchPostsDataRequest(text: text)),
                     scheduler: WorkScheduler.mainScheduler,
                     responseObject: Posts?.self)
    }
}

struct SearchPostsDataRequest: NetworkTarget {

    let text: String

    init(text: String) {
        self.text = text
    }

    var baseURL: BaseURLType {
        return .baseApi
    }

    var version: VersionType {
        return .v3
    }

    var path: String? {
        return "/posts/search"
    }

    var methodType: HTTPMethod {
        .get
    }

    var queryParams: [String: String]? {
        return ["q": text]
    }
    


    var queryParamsEncoding: URLEncoding? {
        return .default
    }
}
