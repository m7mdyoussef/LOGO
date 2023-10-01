
import Foundation
import Combine

protocol HomeViewModelProtocol:ObservableObject {
    func getPosts()
}

protocol DefaultHomeViewModel: HomeViewModelProtocol { }

final class HomeViewModel: DefaultViewModel, DefaultHomeViewModel {

    let title: String = Constants.Title.mainTitle
    
    private let postUsecase: PostUsecaseProtocol
    private let searchPostUsecase: SearchPostUsecaseProtocol
     let cacherepository: PostsCasheRepositoryProtocol
    
    var limit: Int = 10
    var skip: Int = 0
    
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
    
    
    
    func callFirstTime() {
        guard self.posts.isEmpty else {return}
        self.getPosts()
    }
    
    func loadMore() {
        self.getPosts()
    }
    
    
    func getPosts() {
        self.callWithProgress(argument: self.postUsecase.execute(limit: limit, skip: skip)) { [ weak self] data in
            guard let self = self else {return}
            
            self.posts.append(contentsOf: data?.posts ?? [])
            _ = try? self.cacherepository.deleteAllCashe()
            _ = try? self.cacherepository.save(self.posts)
            self.skip += 10
        }
    }
    
    func getCashedPosts(){
        let cashedPosts = self.cacherepository.fetch()
        self.posts = cashedPosts ?? []
    }
    
    func searchPostsData(text: String) {
        self.callWithProgress(argument: self.searchPostUsecase.execute(text: text)) { [weak self] data in
            guard let data = data else {return}
            self?.searchData = []
            self?.searchData = data.posts ?? []
        }
    }
    
    
}
