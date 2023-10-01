
import Foundation
import Combine

/// SignInViewModelProtocol will be conformed from SignInViewModel
protocol SignInViewModelProtocol:ObservableObject {
    /// sign in method will be Stubbed to execute viewModel custom useCases method to complete signIn Api
    /// - Parameters:
    ///   - user_Name: userName is a String data for user that must be exist in Server side
    ///   - passwrd: passwrd is a String data for user that must be exist in Server side
    func signIn(user_Name: String,
                passwrd: String)
}

protocol DefaultSignInViewModel: SignInViewModelProtocol { }

final class SignInViewModel:DefaultViewModel, DefaultSignInViewModel {

    private let signInUsecase: SignInUsecaseProtocol
    
    @Published var userName = ""
    @Published var password = ""
    @Published var errorMessage = ""
    @Published var isSecured = true
    @Published var enableSignIn = false
    
    var navigateSubject = PassthroughSubject<SignInView.Routes, Never>()
    var signInState = CurrentValueSubject<Bool, Never>(false)
    
    private var userNameValidPublisher: AnyPublisher<Bool, Never>{
        return $userName
            .map{!$0.isEmpty}
            .eraseToAnyPublisher()
    }
    
    private var passwordValidPublisher: AnyPublisher<Bool, Never>{
        return $password
            .map{!$0.isEmpty}
            .eraseToAnyPublisher()
    }
    
    init(signInUsecase: SignInUsecaseProtocol = DIContainer.shared.inject(type: SignInUsecaseProtocol.self)!) {
        self.signInUsecase = signInUsecase

    }
}


extension SignInViewModel: DataFlowProtocol{
    typealias InputType = Load
    
    enum Load {
        case onAppear
    }
    
    func apply(_ input: Load) {
        switch input {
        case .onAppear:
            self.bindData()
        }
    }
    
    /// navigation method to home screen
    func navigateToHome() {
        self.navigateSubject.send(.home)
    }
    
    /// bind Auth text filds together to ensure that both fields are containning data then enable of disable Sign In button
    private func bindData(){
        Publishers.CombineLatest(userNameValidPublisher
                                  ,passwordValidPublisher)
        .map{ userName, password in
            return userName && password
        }
        .receive(on: WorkScheduler.mainThread)
        .assign(to: \.enableSignIn, on: self)
        .store(in: subscriber)
    }
    
    func signIn(user_Name: String, passwrd: String) {
        self.callWithProgress(argument: self.signInUsecase.execute(userName: user_Name,
                                                                   password: passwrd)) { [weak self] data in
            guard let self = self else {return}
            self.signInState.send(true)

        }
    }
    
}
