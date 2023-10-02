
import SwiftUI

struct HomeView: Coordinatable {
    typealias Route = Routes
    
    //Properties
    @StateObject var viewModel: HomeViewModel
    @State private var isLoggoVisible = true
    @State private var isSearchBarVisible = false
    @State private var shouldShowDropdown = false
    @State private var searchText: String = .empty
    @State private var isLoading: Bool = false
    @State private var cashedDataPresented: Bool = false
    @State private var presentAlert = true
    @State private var alertMesagee: String = ""
    let subscriber = Cancelable()
    
    enum Constant {
        static let topPadding: CGFloat = 5
        static let searchHeight: CGFloat = 48
    }
    
    //body
    var body: some View {
        NavigationView {
            ZStack {
                VStack{
                    if isLoggoVisible{
                        HStack{
                            Image(Assets.logo)
                            Spacer()
                            Button {
                                isLoggoVisible = false
                            } label: {
                                Image(Assets.search)
                            }//: Button
                        }//: HStack
                        .padding()
                    }else{
                        self.showSearchField()
                    }
                    
                    Divider()
                    
                    PostListView(viewModel: viewModel, postType: .posts, isLoading: $isLoading, cashedDataPresented: $cashedDataPresented)
                }//: VStack
                
                TabBar()
                if !presentAlert{
                    self.showAlert(Constants.Alert.Error, alertMesagee)
                }
            }//: ZStack
            .onViewDidLoad {
                self.viewModel.apply(.onAppear)
            }
        }//: NavigationView
        .onAppear(perform: handleState)
    }
    
    //functions
    /// showSearchField functions shows overlay view of Search Bar with the posts results
    /// - Returns: returns a view of Search Bar with the posts results
    func showSearchField() -> some View{
        SearchBar(isLoading: isLoading,
                  text: $viewModel.searchText,
                  isEditing: $shouldShowDropdown ,didTapCancelSearch: {
            isLoggoVisible = true
        })
        .padding(.horizontal, 10)
        .overlay(
            VStack {
                if self.shouldShowDropdown {
                    Spacer(minLength: Constant.searchHeight)
                    PostListView(viewModel: viewModel, postType: .search, isLoading: $isLoading, cashedDataPresented: $cashedDataPresented)
                        .frame(height: UIScreen.screenHeight)
                        .padding(.vertical, 5)
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 0)
                                .stroke(Color.lightGreyColor, lineWidth: 0.5)
                        )
                }
            }, alignment: .topLeading
        )
        .background(
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.white)
        )
        .zIndex(1)
        .padding(.top, Constant.topPadding)
    }
}

extension HomeView {
    /// handle Api response state to show / hide alerts and how / hide loader
    private func handleState() {
        self.viewModel.loadingState
            .receive(on: WorkScheduler.mainThread)
            .sink { state in
                switch state {
                case .loadStart:
                    self.isLoading = true
                    self.cashedDataPresented = false
                case .dismissAlert:
                    self.isLoading = false
                    self.cashedDataPresented = false
                case .emptyStateHandler(let message, _):
                    self.isLoading = false
                    self.presentAlert = false
                    self.alertMesagee = message
                    self.viewModel.getCashedPosts()
                    self.cashedDataPresented = true
                }
            }.store(in: subscriber)
    }
}

extension HomeView {
    /// show Alert with title and message
    /// - Parameters:
    ///   - title: alert title shows general description of the showing reason
    ///   - message: alert message shows a description of showing alert
    /// - Returns: returns the alert view with alert components
    func showAlert(_ title: String, _ message: String) -> some View {
        CustomAlertView(title: title, message: message, primaryButtonLabel: Constants.Alert.Retry, primaryButtonAction: {
            self.presentAlert = true
            self.viewModel.callFirstTime()
        } , secondaryButtonLabel: Constants.Alert.OK, secondaryButtonAction: {
            self.presentAlert = true
        })
        .previewLayout(.sizeThatFits)
        .padding()
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: HomeViewModel())
    }
}

enum PostType{
    case posts
    case search
}

extension HomeView {
    enum Routes: Routing {
        case showImg(imageName: String,
                     isImageTapped: Bool)
    }
}
