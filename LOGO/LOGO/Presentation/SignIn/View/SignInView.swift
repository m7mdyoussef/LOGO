

import SwiftUI
import Combine

struct SignInView: Coordinatable {
    //properties
    typealias Route = Routes
    @AppStorage(Constants.Cashe.isLoggedIn) var isLoggedIn:Bool = false
    @StateObject var viewModel: SignInViewModel
    
    enum Constant {
        static let cornerRadius: CGFloat = 10
    }
    
    @State private var isLoading: Bool = false
    @State private var presentAlert = true
    @State private var alertMesagee: String = ""

    let subscriber = Cancelable()
    
    //body
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators:false){
                ZStack{
                    VStack{
                        VStack(alignment: .center, spacing: 30.0){
                            Image(Assets.loginPanner)
                                .resizable()
                                .scaledToFill()
                            Text(Constants.Auth.welcome)
                                .foregroundColor(Color.primaryColor)
                                .font(.title3)
                                .fontWeight(.bold)
                            
                        }//: VStack
                      //  Spacer()
                        
                        LazyVStack(spacing: 10){
                                                
                            AuthTextView(textValue: $viewModel.userName, isSecured: $viewModel.isSecured, isPassword:false, title: Constants.Auth.userNamePlaceHolder, authHeader: Constants.Auth.userNameTitle,keyboardType: .emailAddress)

                            AuthTextView(textValue: $viewModel.password, isSecured: $viewModel.isSecured, isPassword:true, title: Constants.Auth.passwordPlaceHolder, authHeader: Constants.Auth.passwordTitle,keyboardType: .default)
                              
                            Spacer()
                            Button {
                                viewModel.signIn(user_Name: viewModel.userName, passwrd: viewModel.password)
                                
                            }label: {
                                Text (Constants.Auth.SignIn)
                            }//: Button
                            .disabled(!viewModel.enableSignIn)
                            .padding(20)
                            .font(.system(size: 17, design: .rounded))
                            .font(.title2)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(Color .white)
                            .background(viewModel.enableSignIn ? Color.primaryColor : Color.gray)
                            .cornerRadius(.infinity)
                        }//: LazyVStack
                        .padding(.horizontal, 16)
                        
                        Spacer()

                    }//: VStack
                    .onViewDidLoad {
                        self.viewModel.apply(.onAppear)
                    }
                    
                    if !presentAlert{
                        self.showAlert(Constants.Alert.Error, alertMesagee)
                    }
                    
                    if isLoading {
                        ZStack {
                            RoundedRectangle(cornerRadius: Constant.cornerRadius)
                                .foregroundColor(Color.white.opacity(0.9))
                                .frame(width: 90.0, height: 90.0)
                            ActivityIndicator(style: .large, animate: .constant(true))
                        }
                    }
                }//: ZStack
            }//: ScrollView
            .ignoresSafeArea(.all, edges: [.top])
            
        }//: NavigationView
        .onAppear(perform: handleState)
    }
}

extension SignInView {
    /// Routes enum for SignIn View contains all navigation cases that will be accessed from the coordinator
    enum Routes: Routing {
        case home
    }
}

extension SignInView {
    /// handle Api response state to show / hide alerts and how / hide loader
    private func handleState() {
        self.viewModel.loadingState
            .receive(on: WorkScheduler.mainThread)
            .sink { state in
                switch state {
                case .loadStart:
                    self.isLoading = true
                case .dismissAlert:
                    self.isLoading = false
                case .emptyStateHandler(let message, _):
                    self.isLoading = false
                    self.presentAlert = false
                    self.alertMesagee = message
                }
            }.store(in: subscriber)
        
        self.viewModel.signInState
            .receive(on: WorkScheduler.mainThread)
            .sink { state in
                if state == true{
                    self.isLoggedIn = true
                    self.viewModel.navigateToHome()
                }
            }.store(in: subscriber)
    }
}

extension SignInView {
    /// show Alert with title and message
    /// - Parameters:
    ///   - title: alert title shows general description of the showing reason
    ///   - message: alert message shows a description of showing alert
    /// - Returns: returns the alert view with alert components
    func showAlert(_ title: String, _ message: String) -> some View {
        CustomAlertView(title: title, message: message, primaryButtonLabel: Constants.Alert.Retry, primaryButtonAction: {
            self.presentAlert = true
        })
        .previewLayout(.sizeThatFits)
        .padding()
    }
}


struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(viewModel: SignInViewModel() )
    }
}

