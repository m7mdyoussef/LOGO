//
//  MarketPriceRepository.swift
//  EasyCrypto
//
//  Created by Mehran on 11/15/1401 AP.
//

import Foundation
import Combine

protocol PostsRepositoryProrocol {
    func data(limit: Int,
              skip: Int) -> AnyPublisher<Posts?, APIError>
}

final class PostsRepository {

    private let service: PostsRemoteProtocol

    init(service: PostsRemoteProtocol = DIContainer.shared.inject(type: PostsRemoteProtocol.self)!) {
        self.service = service
    }
}

extension PostsRepository: PostsRepositoryProrocol {
    func data(limit: Int,
              skip: Int) -> AnyPublisher<Posts?, APIError> {
        return self.service.fetch(limit: limit, skip: skip)
    }
}
