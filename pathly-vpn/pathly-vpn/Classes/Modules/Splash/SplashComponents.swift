//
//  SplashComponents.swift
//  pathly-vpn
//
//  Created by Александр on 07.11.2024.
//

import UIKit

struct SplashComponents {
    var viewController: UIViewController
    var presenter: SplashPresenterInterface
    
    static func make(apiService: APINetworkServiceInterface, storageService: StorageServiceInterface) -> SplashComponents {
        let view = SplashViewController()
        let presenter = SplashPresenter(
            view: view,
            apiService: apiService,
            storageService: storageService
        )
        view.presenter = presenter
        return SplashComponents(viewController: view, presenter: presenter)
    }
    
}
