
import XCTest
import Combine
@testable import LOGO

final class SignInViewModelTest: XCTestCase {

    private var viewModelToTest: SignInViewModel!
    private var signInRemote: SignInRemoteMock!
    private var subscriber : Set<AnyCancellable> = []
    private var input: SignInViewModel.InputType!
    
    override func setUp()  {
        viewModelToTest = SignInViewModel()
        signInRemote = SignInRemoteMock()
        input = SignInViewModel.InputType.onAppear
    }
    
    override func tearDown() {
        subscriber.forEach { $0.cancel() }
        subscriber.removeAll()
        viewModelToTest = nil
        signInRemote = nil
        input = nil
        super.tearDown()
    }
    
    func testSignInViewModel_WhenSignInServiceCalled_ShouldReturnResponse() {
        //Arrange
        let data = User.mockUser

        let expectation = XCTestExpectation(description: "State")
        // Act
        viewModelToTest.loadingState.dropFirst().sink { event in
            XCTAssertEqual(event, .loadStart)
              expectation.fulfill()
        }.store(in: &subscriber)
        // Assert
        signInRemote.fetchedResult = Result.success(data).publisher.eraseToAnyPublisher()
        viewModelToTest.signIn(user_Name: "kminchelle", passwrd: "0lelplR")

        wait(for: [expectation], timeout: 1)
    }
    
    func testSignInViewModel_WhenSignInServiceCalled_ShouldReturnNil() {
        //Arrange
        let data:User? = nil

        let expectation = XCTestExpectation(description: "State")
        // Act
        viewModelToTest.loadingState.dropFirst().sink { event in
            XCTAssertEqual(event, .loadStart)
              expectation.fulfill()
        }.store(in: &subscriber)
        // Assert
        signInRemote.fetchedResult = Result.success(data).publisher.eraseToAnyPublisher()
        viewModelToTest.signIn(user_Name: "kminchelle", passwrd: "0lelplR")

        wait(for: [expectation], timeout: 1)
    }



}
