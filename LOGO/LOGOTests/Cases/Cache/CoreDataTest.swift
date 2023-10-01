
import XCTest
import CoreData
import Combine
@testable import LOGO

final class CoreDataTest: CacheStack {
    
    var sut: CoreDataManagerProtocol!
    private var subscriber : Set<AnyCancellable> = []

    override func setUp() {
        sut = CoreDataManager(container: mockPersistentContainer)
    }

    override func tearDown() {
        subscriber.forEach { $0.cancel() }
        subscriber.removeAll()
        sut = nil
        clearMockData()
        super.tearDown()
    }
}

extension CoreDataTest {
    func testCoreDataSave_WhenSaveData_ShouldSaveMockData() {
        let  data = Posts.mockPost
        
        let mockAction: Action = {
            let post = NSEntityDescription.insertNewObject(forEntityName: "PostENt",
                                                           into: self.mockPersistentContainer.viewContext)
            post.setValue(data.id, forKey: "id")
            post.setValue(data.title, forKey: "title")
            post.setValue(data.body, forKey: "body")
        }
        
        sut.publisher(save: mockAction)
            .sink { completion in
                
            } receiveValue: { state in
                XCTAssertEqual(state, true)
            }.store(in: &subscriber)
    }
    
    func testCoreDataFetch_WhenFetchData_ShouldSaveMockData() {
        let request: NSFetchRequest<PostENt> = PostENt.fetchRequest()
        sut.publisher(fetch: request)
            .sinkOnMain { _ in
            } receiveValue: { data in
                XCTAssertEqual(data.count, 1)
            }.store(in: &subscriber)
    }
}
