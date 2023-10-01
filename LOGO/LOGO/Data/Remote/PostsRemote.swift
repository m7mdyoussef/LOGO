
import Foundation
import Combine

protocol PostsRemoteProtocol: AnyObject {
     func fetch(limit: Int,
                skip: Int) -> AnyPublisher<Posts?, APIError>
}

final class PostsRemote: NetworkClientManager<HttpRequest>, PostsRemoteProtocol {
    func fetch(limit: Int,
               skip: Int) -> AnyPublisher<Posts?, APIError> {
        self.request(request: HttpRequest(request: PostsRequest(limit: limit, skip: skip)),
                     scheduler: WorkScheduler.mainScheduler,
                     responseObject: Posts?.self)
    }
}

struct PostsRequest: NetworkTarget {
    let limit: Int
    let skip: Int

    init(limit: Int,
         skip: Int) {
        self.limit = limit
        self.skip = skip
    }

    var baseURL: BaseURLType {
        return .baseApi
    }

    var path: String? {
        return "/posts"
    }

    var methodType: HTTPMethod {
        .get
    }

    var queryParams: [String: String]? {
        return ["limit": String(limit),
                "skip": String(skip)]
    }

    var queryParamsEncoding: URLEncoding? {
        return .default
    }
}
