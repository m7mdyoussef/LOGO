//
//  SignInViewModel.swift
//  CleanArchProject
//
//  Created by mohamed youssef on 25/09/2023.
//

import Foundation
import Combine

protocol SignInViewModelProtocol:ObservableObject {
    func signIn()
}

protocol DefaultSignInViewModel: SignInViewModelProtocol { }

final class SignInViewModel:DefaultViewModel, DefaultSignInViewModel {

    private let signInUsecase: SignInUsecaseProtocol
    
    @Published var userName = ""
    @Published var password = ""
    @Published var errorMessage = ""
    @Published var isSecured = true
    @Published var enableSignIn = false
    
    @Published var userData: User?
    
    var navigateSubject = PassthroughSubject<SignInView.Routes, Never>()
    
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
    
    func navigateToHome() {
        self.navigateSubject.send(.home)
    }
    
    private func bindData(){
//        userNameValidPublisher
//            .receive(on: WorkScheduler.mainThread)
//            .dropFirst()
//            .map{ $0 ? "" : "User name is missing" }
//            .assign(to: \.errorMessage, on: self)
//            .store(in: subscriber)
//
//        passwordValidPublisher
//            .receive(on: WorkScheduler.mainThread)
//            .dropFirst()
//            .map{ $0 ? "" : "password is missing" }
//            .assign(to: \.errorMessage, on: self)
//            .store(in: subscriber)
        
      
        
        Publishers.CombineLatest(userNameValidPublisher
                                  ,passwordValidPublisher)
        .map{ userName, password in
            return userName && password
        }
        .receive(on: WorkScheduler.mainThread)
        .assign(to: \.enableSignIn, on: self)
        .store(in: subscriber)
    }
    
    func signIn() {
        self.callWithProgress(argument: self.signInUsecase.execute(userName: userName,
                                                                   password: password)) { [weak self] data in
            guard let self = self else {return}
            self.userData = data
            
        }
    }
    
}
