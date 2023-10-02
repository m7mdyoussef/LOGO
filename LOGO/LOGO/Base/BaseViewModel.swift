
import Foundation
import Combine

/// ViewModel Status of the Api responses
enum ViewModelStatus: Equatable {
    case loadStart
    case dismissAlert
    case emptyStateHandler(title: String, isShow: Bool)
}

/// BaseViewModelEventSource holds the Status of the Api responses
protocol BaseViewModelEventSource: AnyObject {
    var loadingState: CurrentValueSubject<ViewModelStatus, Never> { get }
}

/// ViewModelService calls the Apis with an argument of type AnyPublisher
protocol ViewModelService: AnyObject {
    func callWithProgress<ReturnType>(argument: AnyPublisher<ReturnType?,
                                      APIError>,
                                      callback: @escaping (_ data: ReturnType?) -> Void)
    func callWithoutProgress<ReturnType>(argument: AnyPublisher<ReturnType?,
                                         APIError>,
                                         callback: @escaping (_ data: ReturnType?) -> Void)
}

typealias BaseViewModel = BaseViewModelEventSource & ViewModelService

/// DefaultViewModel  is the base for each viewModel with api calls
open class DefaultViewModel: BaseViewModel, ObservableObject {

    var loadingState = CurrentValueSubject<ViewModelStatus, Never>(.dismissAlert)
    let subscriber = Cancelable()
    
    /// callWithProgress Method that handle both response and error status to show/hide alerts and loaders
    /// - Parameters:
    ///   - argument: accept argument of type AnyPublisher with generic ReturnType or custom Error
    ///   - callback: callback returns the Generic response Data
    func callWithProgress<ReturnType>(argument: AnyPublisher<ReturnType?,
                                      APIError>,
                                      callback: @escaping (_ data: ReturnType?) -> Void) {
        self.loadingState.send(.loadStart)

        let completionHandler: (Subscribers.Completion<APIError>) -> Void = { [weak self] completion in
            switch completion {
            case .failure(let error):
                self?.loadingState.send(.dismissAlert)
                self?.loadingState.send(.emptyStateHandler(title: error.desc, isShow: true))
            case .finished:
                print("sucess")
                self?.loadingState.send(.dismissAlert)
            }
        }

        let resultValueHandler: (ReturnType?) -> Void = { data in
            callback(data)
        }

        argument
            .subscribe(on: WorkScheduler.backgroundWorkScheduler)
            .receive(on: WorkScheduler.mainScheduler)
            .sink(receiveCompletion: completionHandler, receiveValue: resultValueHandler)
            .store(in: subscriber)
    }
    
    /// callWithoutProgress Method that handle only the response without showing/hide alerts or loaders
    /// - Parameters:
    ///   - argument: accept argument of type AnyPublisher with generic ReturnType or custom Error
    ///   - callback: callback returns the Generic response Data
    func callWithoutProgress<ReturnType>(argument: AnyPublisher<ReturnType?,
                                         APIError>,
                                         callback: @escaping (_ data: ReturnType?) -> Void) {

        let resultValueHandler: (ReturnType?) -> Void = { data in
            callback(data)
        }

        argument
            .subscribe(on: WorkScheduler.backgroundWorkScheduler)
            .receive(on: WorkScheduler.mainScheduler)
            .sink(receiveCompletion: {_ in }, receiveValue: resultValueHandler)
            .store(in: subscriber)
    }
}
