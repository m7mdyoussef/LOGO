

import Foundation
import CoreData
import Combine

protocol PostsCasheRepositoryProtocol {
    func save(_ data: [Post]) throws
    func fetch() -> [Post]?
    func fetchItem(_ id: Int) -> Post?
    func findByID(_ matchID: Int64) -> Post?
    func deleteAllCashe() throws
}

final class PostsCacheRepository: PostsCasheRepositoryProtocol {
    

    let coreDataManager: CoreDataManagerProtocol
    let subscriber = Cancelable()

    init(coreDataManager: CoreDataManagerProtocol = DIContainer.shared.inject(type: CoreDataManagerProtocol.self)!) {
        self.coreDataManager = coreDataManager
    }

    func save(_ posts: [Post]) {
        let action: Action = {
            
            for post in posts{
                let postEnt = NSEntityDescription.insertNewObject(forEntityName: Constants.DBName.postENt,
                                                               into: self.coreDataManager.viewContext)
                postEnt.setValue(post.id, forKey: "id")
                postEnt.setValue(post.title, forKey: "title")
                postEnt.setValue(post.body, forKey: "body")
            }

        }
        
        self.coreDataManager
            .publisher(save: action)
            .sinkOnMain { completion in
                switch completion {
                case .failure(let error):
                    log("Saving Failure: \(error)")
                case .finished:
                    log("Completion")
                }
            } receiveValue: { success in
                if success {
                    log("Saving Done)")
                }
            }.store(in: subscriber)
    }
    


    func fetch() -> [Post]? {
        let request: NSFetchRequest<PostENt> = PostENt.fetchRequest()
        var output: [Post] = []
        self.coreDataManager
            .publisher(fetch: request)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    log("FetchData Failure: \(error)")
                case .finished:
                    log("Completion")
                }
            } receiveValue: { value in
                value.forEach { postItem in
                            output.append(Post(id: Int(postItem.id),
                                                   title: postItem.title,
                                                   body: postItem.body))
                        }
                
            }.store(in: subscriber)
        return output
    }
    
    func fetchItem(_ id: Int) -> Post? {
        if let matchData = findByID(Int64(id)) {
            return matchData
        }
        return nil
    }
    
    func findByID(_ id: Int64) -> Post? {
        let request: NSFetchRequest<PostENt> = PostENt.fetchRequest()
        let idPredicate = NSPredicate(format: "id == %d", id)
        request.predicate = idPredicate
        var output: Post?
        self.coreDataManager
            .publisher(fetch: request)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    log("FetchData Failure: \(error)")
                case .finished:
                    log("Completion")
                }
            } receiveValue: { value in
                output = Post(id: Int(value.first?.id ?? 0), title: value.first?.title, body: value.first?.body)
            }.store(in: subscriber)
        return output
    }
    
    func deleteAllCashe() throws {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: PostENt.entityName)
        self.coreDataManager
            .publisher(delete: request)
            .sinkOnMain { completion in
                switch completion {
                case .failure(let error):
                    log("Delete Failure: \(error)")
                case .finished:
                    log("Completion")
                }
            } receiveValue: { _ in }
            .store(in: subscriber)
    }

}
