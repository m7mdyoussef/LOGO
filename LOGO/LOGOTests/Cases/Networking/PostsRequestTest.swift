
import XCTest
@testable import LOGO

final class PostsRequestTest: XCTestCase {

    var sut: NetworkTarget!

    override func setUp() {
        sut = DummyTarget()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testNetworkTarget_WhenBaseURl_ShouldReturnString() {
        XCTAssertTrue(sut.baseURL.desc as Any is URL)
    }
    
    func testNetworkTarget_WhenBaseURl_ShouldReturnURL() {
        XCTAssertEqual(sut.baseURL.desc, URL("https://dummyjson.com"))
    }
    
    func testNetworkTarget_WhenPath_ShouldBeRequestType() {
        XCTAssertTrue(sut.path as Any is String)
    }
    
    func testNetworkTarget_WhenPath_ShouldReturnPath() {
        XCTAssertEqual(sut.path, "test/test")
    }

    func testNetworkTarget_WhenMethod_ShouldReturnType() {
        XCTAssertEqual(sut.methodType, .get)
    }
    
    func testNetworkTarget_QueryParam_ShouldReturnType() {
        XCTAssertEqual(sut.queryParamsEncoding, .default)
    }
}
