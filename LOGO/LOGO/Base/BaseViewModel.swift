
import Foundation
import Combine

enum ViewModelStatus: Equatable {
    case loadStart
    case dismissAlert
    case emptyStateHandler(title: String, isShow: Bool)
}

protocol BaseViewModelEventSource: AnyObject {
    var loadingState: CurrentValueSubject<ViewModelStatus, Never> { get }
}

protocol ViewModelService: AnyObject {
    func callWithProgress<ReturnType>(argument: AnyPublisher<ReturnType?,
                                      APIError>,
                                      callback: @escaping (_ data: ReturnType?) -> Void)
    func callWithoutProgress<ReturnType>(argument: AnyPublisher<ReturnType?,
                                         APIError>,
                                         callback: @escaping (_ data: ReturnType?) -> Void)
}

typealias BaseViewModel = BaseViewModelEventSource & ViewModelService

open class DefaultViewModel: BaseViewModel, ObservableObject {

    var loadingState = CurrentValueSubject<ViewModelStatus, Never>(.dismissAlert)
    var signInState = CurrentValueSubject<Bool, Never>(false)
    
    let subscriber = Cancelable()

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
                self?.signInState.send(true)
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
