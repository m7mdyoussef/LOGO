
import SwiftUI
import Combine

/// SignIn Coordinator which is responsable for all signIn Flows of navigation
struct SignInCoordinator: CoordinatorProtocol {
    //Properties
    @StateObject var viewModel: SignInViewModel
    @State var activeRoute:Destination?
    @State var transition: Transition?
    let subscriber = Cancelable()

    //body
    var body: some View {
        signInView
            .route(to: $activeRoute)
            .navigation()
            .onAppear {
                self.viewModel
                    .navigateSubject
                    .sink { route in
                        activeRoute = Destination(route: route)
                    }.store(in: subscriber)
            }
    }

    var signInView: SignInView {
        return SignInView(viewModel: viewModel)
    }
}

extension SignInCoordinator {
    /// Destination struct is to detect the content will be navigated to and the transition type of navigation
    struct Destination: DestinationProtocol {
        
        var route: SignInView.Routes
        
        @ViewBuilder
        var content: some View {
            switch route {
            case .home:
                HomeView()
            }
        }
        
        var transition: Transition {
            switch route {
            case .home: return .push
            }
        }
        
    }
}
