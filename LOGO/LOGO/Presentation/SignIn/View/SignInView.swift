

import SwiftUI
import Combine

struct SignInView: Coordinatable {
    
    typealias Route = Routes
    
    @AppStorage("isLoggedIn") var isLoggedIn:Bool = false
    @StateObject var viewModel: SignInViewModel
    
    enum Constant {
        static let cornerRadius: CGFloat = 10
    }
    
    @State private var isLoading: Bool = false
    @State private var presentAlert = true
    @State private var alertMesagee: String = ""



    let subscriber = Cancelable()
    
    var body: some View {
        NavigationView {
            ZStack{
                VStack{
                    VStack(alignment: .center, spacing: 50.0){
                        Image("loginPanner")
                            .resizable()
                            .scaledToFill()
                            .frame(minWidth: 375, maxHeight: 440, alignment: .center)

                        Text("Welcome")
                            .foregroundColor(Color("primaryColor"))
                            .font(.title3)
                            .fontWeight(.bold)
                    }
                    
                    Spacer()
                    
                    LazyVStack(spacing: 20){
                                            
                        AuthTextView(textValue: $viewModel.userName, isSecured: $viewModel.isSecured, isPassword:false, title: "Enter your user name", authHeader: "User Name",keyboardType: .emailAddress)

                        AuthTextView(textValue: $viewModel.password, isSecured: $viewModel.isSecured, isPassword:true, title: "Enter your password", authHeader: "password",keyboardType: .default)
                                        
                        Button {
                            print("Do login")
                            viewModel.signIn()
                            
                           
                        }label: {
                            Text ("Login")
                        }
                        .disabled(!viewModel.enableSignIn)
                        .padding(20)
                        .font(.system(size: 17, design: .rounded))
                        .font(.title2)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(Color .white)
                        .background(viewModel.enableSignIn ? Color("primaryColor") : Color.gray)
                        .cornerRadius(.infinity)
                    }
                    .padding(.horizontal, 16)
                    
                    Spacer()

                }
                .ignoresSafeArea(.all, edges: [.top])
                .onViewDidLoad {
                    self.viewModel.apply(.onAppear)
                }
                
                if !presentAlert{
                    self.showAlert("Error", alertMesagee)
                }
                
                if isLoading {
                    ZStack {
                        RoundedRectangle(cornerRadius: Constant.cornerRadius)
                            .foregroundColor(Color.white.opacity(0.9))
                            .frame(width: 90.0, height: 90.0)
                        ActivityIndicator(style: .large, animate: .constant(true))
                    }
                }
                
            }
            
        }
        .onAppear(perform: handleState)
    }
}

extension SignInView {
    enum Routes: Routing {
        case home
    }
}

extension SignInView {
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
    func showAlert(_ title: String, _ message: String) -> some View {
        CustomAlertView(title: title, message: message, primaryButtonLabel: "Retry", primaryButtonAction: {
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

