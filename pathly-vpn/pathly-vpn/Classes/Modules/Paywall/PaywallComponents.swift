//
//  PaywallComponents.swift
//  pathly-vpn
//
//  Created by Александр on 10.11.2024.
//

import UIKit

enum Paywall {
    case single(dismissDelay: Int)
    case multy
}

struct PaywallComponents {
    
    var viewController: UIViewController
    var presenter: PaywallPresenterInterface
    
    static func make(storeService: StoreServiceInterface, apiService: APINetworkServiceInterface, storageService: StorageServiceInterface, type: Paywall) -> PaywallComponents {
        let viewController: CommonPaywallViewController = {
            switch type {
                case .single:
                    return SinglePaywallViewController()
                case .multy:
                    return MultyPaywallViewController()
            }
        }()
        let presenter = PaywallPresenter(
            view: viewController,
            storeService: storeService, 
            apiService: apiService, 
            storageService: storageService,
            type: type
        )
        viewController.presenter = presenter
        return PaywallComponents(viewController: viewController, presenter: presenter)
    }
    
}
