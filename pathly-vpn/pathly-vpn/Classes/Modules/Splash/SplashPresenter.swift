//
//  SplashPresenter.swift
//  pathly-vpn
//
//  Created by Александр on 07.11.2024.
//

import Foundation
import Combine

protocol SplashPresenterInterface {
    var view: SplashView? { get set }
    var didFinish: Completion? { get set }
    
    func viewDidLoad()
    func viewDidFinish()
}

class SplashPresenter {
    weak var view: SplashView?
    var didFinish: Completion?
    
    private var cancellables = Set<AnyCancellable>()
    private var apiService: APINetworkServiceInterface
    private var storageService: StorageServiceInterface
    private var group: DispatchGroup = DispatchGroup()
    
    init(view: SplashView, apiService: APINetworkServiceInterface, storageService: StorageServiceInterface) {
        self.view = view
        self.apiService = apiService
        self.storageService = storageService
    }
    
    private func getServers(completion: ((Result<[Server], ErrorResponse>) -> Void)?) {
        self.apiService.application.servers(apiKey: Constants.apiKey).sink { completionHandler in
            switch completionHandler {
                case .failure(let error):
                    completion?(.failure(error))
                default:
                    break
            }
        } receiveValue: { response in
            completion?(.success(response))
        }.store(in: &cancellables)
    }
    
}

extension SplashPresenter: SplashPresenterInterface {
    
    func viewDidLoad() {
        group.enter()
        group.enter()
        
        self.getServers { [weak self] result in
            switch result {
            case .success(let servers):
                self?.storageService.servers = servers
            case .failure(let error):
                break
            }
            self?.group.leave()
        }
        
        group.notify(queue: .main, execute: { [weak self] in
            self?.didFinish?()
        })
    }
    
    func viewDidFinish() {
        group.leave()
    }
    
}
