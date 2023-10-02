
import SwiftUI
import Combine

/// SignIn Coordinator which is responsable for all signIn Flows of navigation
struct HomeCoordinator: CoordinatorProtocol {
    
    //Properties
    @StateObject var viewModel: HomeViewModel
    @State var activeRoute:Destination?
    @State var transition: Transition?
    let subscriber = Cancelable()

    //body
    var body: some View {
        mainView
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

    var mainView: HomeView {
        return HomeView(viewModel: viewModel)
    }
}

extension HomeCoordinator {
    /// Destination struct is to detect the content will be navigated to and the transition type of navigation
    struct Destination: DestinationProtocol {
        
        var route: HomeView.Routes
        
        @ViewBuilder
        var content: some View {
            switch route {
            case .showImg(let imageName, let isImageTapped):
                ImageOverlayView(imageName: imageName, isImageTapped: isImageTapped)
            }
        }
        
        var transition: Transition {
            switch route {
            case .showImg: return .bottomSheet
            }
        }
        
    }
}

