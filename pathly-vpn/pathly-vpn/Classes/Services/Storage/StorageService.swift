//
//  StorageService.swift
//  pathly-vpn
//
//  Created by Александр on 07.11.2024.
//

import Foundation

protocol StorageServiceInterface {
    var isOnboardingShowed: Bool { get set }
    var isPrivacyShowed: Bool { get set }
    var servers: [Server]? { get set }
    var currentLocationId: String? { get set }
}

class StorageService {
    
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
    var servers: [Server]?
    
}

extension StorageService: StorageServiceInterface {
    
}
