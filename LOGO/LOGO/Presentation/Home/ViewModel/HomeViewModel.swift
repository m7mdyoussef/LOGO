
import Foundation
import Combine

/// HomeViewModelProtocol will be conformed from HomeViewModel
protocol HomeViewModelProtocol:ObservableObject {
    /// getPosts method will be Stubbed to execute viewModel custom useCases method to complete getPosts Api
    func getPosts()
}

protocol DefaultHomeViewModel: HomeViewModelProtocol { }

final class HomeViewModel: DefaultViewModel, DefaultHomeViewModel {
    
    private let postUsecase: PostUsecaseProtocol
    private let searchPostUsecase: SearchPostUsecaseProtocol
    private let cacherepository: PostsCasheRepositoryProtocol
    
    private var limit: Int = 10
    private var skip: Int = 0
    
    @Published var searchText: String = .empty
    @Published var posts: [Post] = []
    @Published var searchData: [Post] = []
        
    init(postUsecase: PostUsecaseProtocol = DIContainer.shared.inject(type: PostUsecaseProtocol.self)!,
         searchPostUsecase: SearchPostUsecaseProtocol = DIContainer.shared.inject(type: SearchPostUsecaseProtocol.self)!,
         cacherepository: PostsCasheRepositoryProtocol = DIContainer.shared.inject(type: PostsCasheRepositoryProtocol.self)!) {
        self.postUsecase = postUsecase
        self.searchPostUsecase = searchPostUsecase
        self.cacherepository = cacherepository
    }
}

extension HomeViewModel: DataFlowProtocol {
    
    typealias InputType = Load
    
    enum Load {
        case onAppear
    }
    
    func apply(_ input: Load) {
        switch input {
        case .onAppear:
            self.bindData()
            self.callFirstTime()
        }
    }
    
    /// bind search text fild to call searchPostsData with its value
    private func bindData() {
        $searchText
            .debounce(for: 1.0, scheduler: WorkScheduler.mainThread)
            .removeDuplicates()
            .sink { [weak self] text in
                guard let self = self else {return}
                if text.isEmpty {
                    self.searchData = []
                } else {
                    guard self.searchData.isEmpty else {return}
                    self.searchPostsData(text: text.lowercased())
                }
            }.store(in: subscriber)
    }
    
    
    
    /// call api method for first time only if posts array is empty to get the first response
    func callFirstTime() {
        guard self.posts.isEmpty else {return}
        self.getPosts()
    }
    
    /// call api method for every time user scroll to the last element of posts array  to get the second limit buffer of Posts.
    func loadMore() {
        self.getPosts()
    }
    
    /// call api method with limit buffer of Posts.
    func getPosts() {
        self.callWithProgress(argument: self.postUsecase.execute(limit: limit, skip: skip)) { [ weak self] data in
            guard let self = self else {return}
            
            self.posts.append(contentsOf: data?.posts ?? [])
            _ = try? self.cacherepository.deleteAllCashe()
            _ = try? self.cacherepository.save(self.posts)
            self.skip += 10
        }
    }
    
    /// get cashed posts only if ther's api error
    func getCashedPosts(){
        let cashedPosts = self.cacherepository.fetch()
        self.posts = cashedPosts ?? []
    }
    
    /// search for custom post with a keyword
    /// - Parameter text: text keyword for searching a post
    func searchPostsData(text: String) {
        self.callWithProgress(argument: self.searchPostUsecase.execute(text: text)) { [weak self] data in
            guard let data = data else {return}
            self?.searchData = []
            self?.searchData = data.posts ?? []
        }
    }
    
    
}
