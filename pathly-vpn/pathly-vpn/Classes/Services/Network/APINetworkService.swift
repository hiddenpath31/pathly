//
//  APIService.swift
//  TwoMatch
//
//  Created by Александр on 11.01.2024.
//

import Foundation

protocol APINetworkServiceInterface {
    var application: ApplicationNetworkServiceInterface { get set }
    var base: BaseNetworkServiceInterface { get set }
}

final class APINetworkService: APINetworkServiceInterface {
    var application: ApplicationNetworkServiceInterface = ApplicationNetworkService()
    var base: BaseNetworkServiceInterface = BaseNetworkService()
}
