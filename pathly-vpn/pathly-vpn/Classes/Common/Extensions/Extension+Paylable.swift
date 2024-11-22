//
//  Extension+Paylable.swift
//  pathly-vpn
//
//  Created by Александр on 10.11.2024.
//

import Foundation
import UIKit

protocol Paylable {
    func showPaywall(storeService: StoreServiceInterface, storageService: StorageServiceInterface, type: Paywall)
}

extension Paylable where Self: UIViewController {

    func showPaywall(storeService: StoreServiceInterface, storageService: StorageServiceInterface, type: Paywall) {
        let apiService: APINetworkServiceInterface = APINetworkService()
        let components = PaywallComponents.make(
            storeService: storeService, 
            apiService: apiService, 
            storageService: storageService,
            type: type
        )
        components.viewController.modalPresentationStyle = .fullScreen
        self.present(components.viewController, animated: true)
    }
    
}
