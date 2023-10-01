
import XCTest
import Combine
@testable import LOGO

final class BaseViewModelTest: XCTestCase {

    private var remote: PostsRemoteMock!
    private var viewModelToTest: DefaultViewModel!
    private var subscriber : Set<AnyCancellable> = []

    override func setUp()  {
        remote = PostsRemoteMock()
        viewModelToTest = DefaultViewModel()
    }

    override func tearDown() {
        subscriber.forEach { $0.cancel() }
        subscriber.removeAll()
        remote = nil
        viewModelToTest = nil
        super.tearDown()
    }

    func testBaseViewModel_WhenCallWithProgress_ShouldReturnValue() {
        //Arrange
        let data = Posts.mock

        remote.fetchedResult = Result.success(data).publisher.eraseToAnyPublisher()

        let expectation = XCTestExpectation(description: "State is set to Token")
        let viewModel = self.viewModelToTest
        // Act
        viewModel?.loadingState.dropFirst().sink { event in
            expectation.fulfill()
            XCTAssertEqual(event, .loadStart)
        }.store(in: &subscriber)

        viewModel?.callWithProgress(argument: self.remote.fetch(limit: 10,
                                                                skip: 0)) { data in
        // Assert
        expectation.fulfill()
         XCTAssertTrue(data?.posts as Any is [Post])
         XCTAssertTrue(data as Any is Decodable)
        }

        viewModel?.loadingState.dropFirst().sink(receiveValue: { event in
            expectation.fulfill()
            XCTAssertEqual(event, .dismissAlert)
        }).store(in: &subscriber)

        wait(for: [expectation], timeout: 1)
    }

    func testBaseViewModel_WhenCallWithProgress_ShouldReturnNil() {
        //Arrange
        let posts = [Post]()
        let data = Posts(posts: posts)

        remote.fetchedResult = Result.success(data).publisher.eraseToAnyPublisher()

        let expectation = XCTestExpectation(description: "State is set to Token")

        let viewModel = self.viewModelToTest
        // Act
        viewModel?.callWithoutProgress(argument: self.remote.fetch(limit: 10,
                                                                   skip: 0)) { data in
        // Assert
        expectation.fulfill()
        XCTAssertTrue(data?.posts as Any is [Post])
        }

        wait(for: [expectation], timeout: 1)
    }
}
