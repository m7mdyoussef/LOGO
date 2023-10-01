//
//  SearchMarketUsecase.swift
//  EasyCrypto
//
//  Created by Mehran on 11/21/1401 AP.
//

import Foundation
import Combine

protocol SearchPostUsecaseProtocol: AnyObject {
    func execute(text: String) -> AnyPublisher<Posts?, APIError>
}

final class SearchPostsUsecase: SearchPostUsecaseProtocol {

    private let searchPostsRepository: SearchPostsRepositoryProtocol

    init(searchPostsRepository: SearchPostsRepositoryProtocol = DIContainer.shared.inject(type: SearchPostsRepositoryProtocol.self)!) {
        self.searchPostsRepository = searchPostsRepository
    }

    func execute(text: String) -> AnyPublisher<Posts?, APIError> {
        return self.searchPostsRepository.data(text: text)
    }
}
