//
//  StorageService.swift
//  pathly-vpn
//
//  Created by Александр on 07.11.2024.
//

import Foundation
import FirebaseRemoteConfig

protocol StorageServiceInterface {
    var isOnboardingShowed: Bool { get set }
    var isPrivacyShowed: Bool { get set }
    var isLastLaunch: Bool { get set }
    var servers: [Server]? { get set }
    var currentLocationId: String? { get set }
    var remoteRespone: RemoteResponse? { get set }
    var isFunnelShowed: Bool { get set }
    var isRemoteLoaded: Bool { get set }
    
    func loadRemoteKeys(completion: Completion?)
}

class StorageService {
    
    var isRemoteLoaded: Bool = false
    var isOnboardingShowed: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "isOnboardingShowed")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "isOnboardingShowed")
        }
    }
    var isPrivacyShowed: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "isPrivacyShowed")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "isPrivacyShowed")
        }
    }
    var currentLocationId: String? {
        get {
            return UserDefaults.standard.string(forKey: "currentLocationId")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "currentLocationId")
        }
    }
    var isLastLaunch: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "isLastLaunch")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isLastLaunch")
        }
    }
    var isFunnelShowed: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "isFunnelShowed")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isFunnelShowed")
        }
    }
    var servers: [Server]?
    var remoteRespone: RemoteResponse?
    
    func loadRemoteKeys(completion: Completion?) {
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
                let subscriptionsValue = remoteConfig.configValue(forKey: "subscriptions").dataValue
                
                let funnelScanFlow: FunnelModel? = try? decoder.decode(FunnelModel.self, from: funnelScanFlowDataValue)
                let funnelCheckFlow: FunnelModel? = try? decoder.decode(FunnelModel.self, from: funnelCheckFlowDataValue)
                let subscription = try? decoder.decode([RemoteSubscription].self, from: subscriptionsValue)
                
                let remoteResponse = RemoteResponse(
                    appkey1: key1,
                    appkey2: key2,
                    dismissDelay: Int(truncating: dismissDelay),
                    scanFlow: funnelScanFlow,
                    checkFlow: funnelCheckFlow,
                    subscriptions: subscription
                )

                self.remoteRespone = remoteResponse
                self.isRemoteLoaded = true
                completion?()
            } else {
                self.isRemoteLoaded = true
                completion?()
            }
        }
    }
    
}

extension StorageService: StorageServiceInterface {

}
