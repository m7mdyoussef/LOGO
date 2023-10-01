
import XCTest
@testable import LOGO

final class UserTest: XCTestCase {

    var sut: User!

    override func setUp() {
        // Arrange
        sut = User.mockUser
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
    
    func testSafeImageURL_ShouldReturnValidType() {
        XCTAssertTrue(sut.safeImageURL() as Any is String)
    }
    
    func testSafeImageURL_ShouldReturnString() {
        XCTAssertEqual(sut.safeImageURL(), "https://robohash.org/autquiaut.png")
    }
    
    func testUser_ShouldReturnValidType() {
        XCTAssertTrue(sut.id as Any is Int)
        XCTAssertTrue(sut.username == "joe")
        XCTAssertTrue(sut.email as Any is String)
        XCTAssertTrue(sut.email == "joe@m.com")
        XCTAssertTrue(sut.firstName as Any is String)
        XCTAssertTrue(sut.firstName == "mohamed")
        XCTAssertTrue(sut.lastName as Any is String)
        XCTAssertTrue(sut.lastName == "youssef")
        XCTAssertTrue(sut.gender as Any is String)
        XCTAssertTrue(sut.gender == "male")
        XCTAssertTrue(sut.image as Any is String)
        XCTAssertTrue(sut.image == "https://robohash.org/autquiaut.png")
    }

}
