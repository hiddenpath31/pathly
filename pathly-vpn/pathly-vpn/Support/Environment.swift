//
//  Environment.swift
//  odola-app
//
//  Created by Александр on 14.09.2024.
//

import Foundation

struct EnvironmentConfiguration {
    enum Environment: String {
        case production = "production"
        case development = "development"
    }
    
    var baseURL: String
    
    static var current: EnvironmentConfiguration {

        if EnvironmentConfiguratorService.shared.manualEnvironment == "prod" {
            return EnvironmentConfiguration.production
        } else if EnvironmentConfiguratorService.shared.manualEnvironment == "dev" {
            return EnvironmentConfiguration.development
        } else {
            if environment() == .production {
                return EnvironmentConfiguration.production
            } else {
                return EnvironmentConfiguration.development
            }
        }
        
    }
    
    static var production: EnvironmentConfiguration = EnvironmentConfiguration(baseURL: Constants.BaseURL.productionURL)
    static var development: EnvironmentConfiguration = EnvironmentConfiguration(baseURL: Constants.BaseURL.developURL)
    
    static func environment() -> Environment {
        //return .production
        // TestFLight, Xcode
        if Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt" {
            return .development
        }
        
        // Simulator
        #if targetEnvironment(simulator)
            return .development
        #else
            return .production
        #endif
    }
    
}

class EnvironmentConfiguratorService: NSObject {
    
    static let shared = EnvironmentConfiguratorService()

    // nil system
    // dev
    // prod
    var manualEnvironment: String? {
        get {
            UserDefaults.standard.string(forKey: "manualEnvironment")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "manualEnvironment")
            UserDefaults.standard.synchronize()
        }
    }
    
}
