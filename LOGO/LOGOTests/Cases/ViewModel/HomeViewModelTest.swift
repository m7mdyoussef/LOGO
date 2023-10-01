
import XCTest
import Combine
@testable import LOGO

final class HomeViewModelTest: XCTestCase {

    private var viewModelToTest: HomeViewModel!
    private var postsRemote: PostsRemoteMock!
    private var searchPosts: MockSearchPostsRemote!
    private var subscriber : Set<AnyCancellable> = []
    
    private var input: HomeViewModel.InputType!
    
    override func setUp()  {
        viewModelToTest = HomeViewModel()
        postsRemote = PostsRemoteMock()
        searchPosts = MockSearchPostsRemote()
        input = HomeViewModel.InputType.onAppear
    }
    
    override func tearDown() {
        subscriber.forEach { $0.cancel() }
        subscriber.removeAll()
        viewModelToTest = nil
        postsRemote = nil
        searchPosts = nil
        input = nil
        super.tearDown()
    }
    
    func testHomeViewModel_WhenPostsServiceCalled_ShouldReturnResponse() {
        //Arrange
        let data = Posts.mock

        let expectation = XCTestExpectation(description: "State")
        // Act
        viewModelToTest.loadingState.dropFirst().sink { event in
            XCTAssertEqual(event, .loadStart)
              expectation.fulfill()
        }.store(in: &subscriber)
        // Assert
        postsRemote.fetchedResult = Result.success(data).publisher.eraseToAnyPublisher()
        viewModelToTest.getPosts()

        wait(for: [expectation], timeout: 1)
    }
    
    func testHomeViewModel_WhenPostsServiceCalled_ShouldReturnNil() {
        //Arrange
        let posts = [Post]()
        let data = Posts(posts: posts)

        let expectation = XCTestExpectation(description: "State")
        // Act
        viewModelToTest.loadingState.dropFirst().sink { event in
            XCTAssertEqual(event, .loadStart)
              expectation.fulfill()
        }.store(in: &subscriber)
        // Assert
        postsRemote.fetchedResult = Result.success(data).publisher.eraseToAnyPublisher()
        viewModelToTest.getPosts()

        wait(for: [expectation], timeout: 1)
    }
    
    func testHomeViewModel_PostsSearchCalled_ShouldReturnResponse() {
        //Arrange
        let data = Posts.mock

        let expectation = XCTestExpectation(description: "State")
        // Act
        viewModelToTest.loadingState.dropFirst().sink { event in
            XCTAssertEqual(event, .loadStart)
              expectation.fulfill()
        }.store(in: &subscriber)
        // Assert
        searchPosts.fetchedResult = Result.success(data).publisher.eraseToAnyPublisher()
        viewModelToTest.searchPostsData(text: "")

        wait(for: [expectation], timeout: 1)
    }
    
    func testHomeViewModel_PostsSearchCalled_ShouldReturnNil() {
        //Arrange
        let data = Posts(posts: nil)

        let expectation = XCTestExpectation(description: "State")
        // Act
        viewModelToTest.loadingState.dropFirst().sink { event in
            XCTAssertEqual(event, .loadStart)
              expectation.fulfill()
        }.store(in: &subscriber)
        // Assert
        searchPosts.fetchedResult = Result.success(data).publisher.eraseToAnyPublisher()
        viewModelToTest.searchPostsData(text: "")

        wait(for: [expectation], timeout: 1)
    }


}
