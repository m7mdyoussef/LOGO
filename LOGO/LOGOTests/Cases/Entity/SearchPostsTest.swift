
import XCTest
@testable import LOGO

final class SearchPostsTest: XCTestCase {

    var sut: Post!

    override func setUp() {
        // Arrange
        sut = Posts.mockPost
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testConformTo_Decodable() {
        XCTAssertTrue(sut as Any is Decodable)
    }
    
    func testConformTo_Equtable() {
        XCTAssertEqual(sut, sut)
    }

    func testCoin_ShouldReturnValidType() {
        XCTAssertTrue(sut.id as Any is Int)
        XCTAssertTrue(sut.id == 1)
        XCTAssertTrue(sut.title as Any is String)
        XCTAssertTrue(sut.title == "His mother had always taught him")
    }
}
