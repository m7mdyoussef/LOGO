
import Foundation
@testable import LOGO

final class DummyTarget: NetworkTarget {
    var baseURL: LOGO.BaseURLType = .baseApi
    
    var version: LOGO.VersionType = .v1
    
    var path: String? = "test/test"
    
    var methodType: LOGO.HTTPMethod = .post
    
    var queryParams: [String : String]? = ["item": "item"]
    
    var queryParamsEncoding: LOGO.URLEncoding? = .default
}
