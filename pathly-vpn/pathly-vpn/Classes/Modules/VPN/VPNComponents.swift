//
//  VPNComponents.swift
//  pathly-vpn
//
//  Created by Александр on 08.11.2024.
//

import UIKit

struct VPNComponents {
    var viewController: UIViewController
    var presenter: VPNPresenterInterface
    
    static func make(storageService: StorageServiceInterface, apiServer: APINetworkServiceInterface, storeService: StoreServiceInterface) -> VPNComponents {
        let viewController = VPNViewController()
        let presenter = VPNPresenter(
            view: viewController,
            storageService: storageService, 
            apiService: apiServer, 
            storeService: storeService
        )
        viewController.presenter = presenter
        return VPNComponents(viewController: viewController, presenter: presenter)
    }
    
}
