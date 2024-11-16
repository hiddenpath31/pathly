//
//  DataComponents.swift
//  pathly-vpn
//
//  Created by Александр on 08.11.2024.
//

import UIKit

struct DataComponents {
    var viewController: UIViewController
    var presenter: DataPresenterInterface
    
    static func make(apiService: APINetworkServiceInterface) -> DataComponents {
        let view = DataViewController()
        let presenter = DataPresenter(
            view: view,
            apiService: apiService
        )
        view.presenter = presenter
        return DataComponents(viewController: view, presenter: presenter)
    }
    
}
