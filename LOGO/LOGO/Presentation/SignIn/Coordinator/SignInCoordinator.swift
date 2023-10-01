
import SwiftUI
import Combine

struct SignInCoordinator: CoordinatorProtocol {
    
    @StateObject var viewModel: SignInViewModel
    @State var activeRoute:Destination?
    @State var transition: Transition?

    @State private var isLoaded: Bool = Bool()

    let subscriber = Cancelable()

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
    struct Destination: DestinationProtocol {
        
        var route: SignInView.Routes
        
        @ViewBuilder
        var content: some View {
            switch route {
            case .home:
                navView()
               // HomeView()
            }
        }
        
        var transition: Transition {
            switch route {
            case .home: return .push
            }
        }
        
    }
}
