

import Foundation
@testable import LOGO

class MockNetworkTarget: NetworkTarget {
    var baseURL: LOGO.BaseURLType = .baseApi
    
    var version: LOGO.VersionType = .v1
    
    var path: String? = "/path"
    
    var methodType: LOGO.HTTPMethod = .get
    
    var queryParams: [String : String]? = ["test": "test"]
    
    var queryParamsEncoding: LOGO.URLEncoding? = .default
}
