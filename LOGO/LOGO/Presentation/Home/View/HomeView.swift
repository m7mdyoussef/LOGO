
import SwiftUI

enum PostType{
    case posts
    case search
}

struct HomeView: View {
    
    enum Constant {
        static let topPadding: CGFloat = 5
        static let searchHeight: CGFloat = 48
        static let spacing: CGFloat = 30
        static let cornerRadius: CGFloat = 10
    }
    
    @StateObject var viewModel: HomeViewModel = HomeViewModel()

    @State private var isLoggoVisible = true
    @State private var isSearchBarVisible = false
    @State private var shouldShowDropdown = false
    @State private var searchText: String = .empty
    @State private var isLoading: Bool = false
    @State private var cashedDataPresented: Bool = false
    @State private var presentAlert = true
    @State private var alertMesagee: String = ""
    let subscriber = Cancelable()
    
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
                        .frame(height: 800)
                        .padding(.vertical, 5)
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 1)
                                .stroke(Color("lightGreyColor"), lineWidth: 1)
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
    
    var body: some View {
        NavigationView {
                ZStack {
                    VStack{
                        if isLoggoVisible{
                            HStack{
                                Image("logo")
                                Spacer()
                                Button {
                                    isLoggoVisible = false
                                    
                                } label: {
                                    Image("search")
                                }
                            }.padding()
                        }else{
                            self.showSearchField()
                        }

                        PostListView(viewModel: viewModel, postType: .posts, isLoading: $isLoading, cashedDataPresented: $cashedDataPresented)
                    }
                    
                    
                    TabBar()
                    if !presentAlert{
                        self.showAlert("Error", alertMesagee)
                    }
                }
            .onViewDidLoad {
                self.viewModel.apply(.onAppear)
            }
        }
        .onAppear(perform: handleState)
    }
}

extension HomeView {
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
    func showAlert(_ title: String, _ message: String) -> some View {
        CustomAlertView(title: title, message: message, primaryButtonLabel: "Retry", primaryButtonAction: {
            self.presentAlert = true
            self.viewModel.callFirstTime()
        } , secondaryButtonLabel: "Ok", secondaryButtonAction: {
            self.presentAlert = true
        })
        .previewLayout(.sizeThatFits)
        .padding()
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

struct PostListView: View {
    
    enum Constant {
        static let cornerRadius: CGFloat = 10
    }
    
    @StateObject var viewModel: HomeViewModel
    var postType:PostType
    @Binding var isLoading: Bool
    @Binding var cashedDataPresented: Bool
    
    var body: some View {
        ScrollView {
                LazyVStack(alignment: .center){
                    let postList = (postType == .posts) ? viewModel.posts : viewModel.searchData
                    ForEach(postList, id: \.id) { post  in
                        VStack(alignment: .leading, spacing: 15){
                            HStack {
                                Image("profileImg")
                                    .resizable()
                                    .clipShape (Circle())
                                    .frame(width: 40, height: 40)
                                    .clipped()
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("mohamed youssef").font(.headline)
                                        .fontWeight(.medium)
                                    Text("Posted 2 hrs ago").font(.subheadline).foregroundColor(.gray)
                                }
                            }
                            
                            Text(post.body ?? "").foregroundColor(Color("darkGrey")) .lineLimit (nil)
                            
                            GeometryReader { geometry in
                                Image("dish1")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: geometry.size.width, height: geometry.size.height)
                                    .clipped()
                                    .cornerRadius(8)
                            }
                            .frame(minHeight: 150, idealHeight: 250)
                        }
                        .padding()
                        
                        Divider().frame(height: 3.0)
                    }
                    
                    if isLoading {
                        ZStack(alignment: .center) {
                            RoundedRectangle(cornerRadius: Constant.cornerRadius)
                                .foregroundColor(Color.white.opacity(0.8))
                                .frame(width: 40.0, height: 40.0)
                            ActivityIndicator(style: .medium, animate: .constant(true))
                        }
                    } else {
                        Color.clear
                            .onAppear {
                                if !isLoading, !self.viewModel.posts.isEmpty, (postType == .posts), !cashedDataPresented {
                                    self.viewModel.loadMore()
                                }
                            }
                    }
                }
        }
    }
}
