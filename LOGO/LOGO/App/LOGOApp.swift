
import SwiftUI

@main
struct LOGOApp: App {

    //Properties
    @AppStorage(Constants.Cashe.isLoggedIn) var isLoggedIn:Bool = false
    let coreDataManager = CoreDataManager.preview
    
    
    //Init
    init() {
        DIContainer.shared.registration()
    }
    
    //body
    var body: some Scene {
        WindowGroup {
            if isLoggedIn{
                HomeCoordinator(viewModel: HomeViewModel())
                    .environment(\.managedObjectContext, coreDataManager.container.viewContext)
            }else{
                SignInCoordinator(viewModel: SignInViewModel())
                    .environment(\.managedObjectContext, coreDataManager.container.viewContext)
            }
            
                
        }
    }
    
}
