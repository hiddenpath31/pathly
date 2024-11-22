//
//  SplashPresenter.swift
//  pathly-vpn
//
//  Created by Александр on 07.11.2024.
//

import Foundation
import Combine
import FirebaseRemoteConfigInternal

protocol SplashPresenterInterface {
    var view: SplashView? { get set }
    var didLoadFinish: ((SplashMode) -> Void)? { get set }
    
    func showFunnel(type: FunnelFlowType)
    func showOrganic()
    
    func viewDidLoad()
    func viewDidFinish()
}

struct RemoteResponse {
    var appkey1: String?
    var appkey2: String?
    var dismissDelay: Int
    var scanFlow: FunnelModel?
    var checkFlow: FunnelModel?
    var subscriptions: [RemoteSubscription]?
    
    var keys: [String] {
        var k: [String] = []
        if let appkey1 = appkey1 {
            k.append(appkey1)
        }
        if let appkey2 = appkey2 {
            k.append(appkey2)
        }
        return k
    }
}

enum SplashMode {
    case organic
    case funnel(flow: FunnelFlowType)
}

class SplashPresenter {
    weak var view: SplashView?
    var didLoadFinish: ((SplashMode) -> Void)?
    
    private var cancellables = Set<AnyCancellable>()
    private var apiService: APINetworkServiceInterface
    private var storageService: StorageServiceInterface
    private var storeService: StoreServiceInterface
    private var group: DispatchGroup = DispatchGroup()
    
    private var mode: SplashMode?
    
    init(view: SplashView, apiService: APINetworkServiceInterface, storageService: StorageServiceInterface, storeService: StoreServiceInterface) {
        self.view = view
        self.apiService = apiService
        self.storageService = storageService
        self.storeService = storeService
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
    
    private func loadRemoteKeys(completion: ((RemoteResponse?) -> Void)?) {
        let remoteConfig = RemoteConfig.remoteConfig()
        remoteConfig.fetch(withExpirationDuration: 0) { (status, error) in
            if status == .success {
                remoteConfig.activate()
                
                let key1 = remoteConfig.configValue(forKey: "appkey1").stringValue
                let key2 = remoteConfig.configValue(forKey: "appkey2").stringValue
                let dismissDelay = remoteConfig.configValue(forKey: "dismissDelay").numberValue
                
                let decoder = JSONDecoder()
                let languageCode = Locale.current.languageCode ?? "en"
                
                let funnelScanFlowDataValue = remoteConfig.configValue(forKey: "scan_flow_\(languageCode)").dataValue
                let funnelCheckFlowDataValue = remoteConfig.configValue(forKey: "check_flow_\(languageCode)").dataValue
                
                let funnelScanFlow: FunnelModel? = try? decoder.decode(FunnelModel.self, from: funnelScanFlowDataValue)
                let funnelCheckFlow: FunnelModel? = try? decoder.decode(FunnelModel.self, from: funnelCheckFlowDataValue)
                
                let remoteResponse = RemoteResponse(
                    appkey1: key1,
                    appkey2: key2,
                    dismissDelay: Int(truncating: dismissDelay),
                    scanFlow: funnelScanFlow,
                    checkFlow: funnelCheckFlow
                )

                completion?(remoteResponse)
                return
            } else {
                completion?(nil)
                return
            }
        }
    }

    private func load() {
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
        
        group.enter()
        self.storeService.load { [weak self] in
            self?.group.leave()
        }

        group.notify(queue: .main, execute: { [weak self] in
            if let mode = self?.mode {
                self?.didLoadFinish?(mode)
            }
        })
    }
    
}

extension SplashPresenter: SplashPresenterInterface {
    
    func showFunnel(type: FunnelFlowType) {
        let mode = SplashMode.funnel(flow: type)
        self.load()
        self.view?.updateUI(mode: mode)
        self.mode = mode
    }
    
    func showOrganic() {
        group.enter()
        self.mode = .organic
        self.view?.updateUI(mode: .organic)
        self.load()
    }
    
    func viewDidLoad() {
        
    }
    
    func viewDidFinish() {
        group.leave()
    }
    
}
