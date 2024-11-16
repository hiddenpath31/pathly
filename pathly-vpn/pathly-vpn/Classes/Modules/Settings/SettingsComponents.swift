//
//  SettingsComponents.swift
//  pathly-vpn
//
//  Created by Александр on 08.11.2024.
//

import UIKit

struct SettingsComponents {
    var viewController: UIViewController
    var presenter: SettingsPresenterInterface
    
    static func make(storeService: StoreServiceInterface) -> SettingsComponents {
        let viewController = SettingsViewController()
        let presenter = SettingsPresenter(
            view: viewController,
            storeService: storeService
        )
        viewController.presenter = presenter
        return SettingsComponents(viewController: viewController, presenter: presenter)
    }
    
}
