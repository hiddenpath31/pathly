//
//  OnboardComponents.swift
//  pathly-vpn
//
//  Created by Александр on 07.11.2024.
//

import UIKit

struct OnboardComponents {
    var viewController: UIViewController
    var presenter: OnboardPresenterInterface
    
    static func make() -> OnboardComponents {
        let vc = OnboardViewController()
        let presenter = OnboardPresenter(view: vc)
        vc.presenter = presenter
        return OnboardComponents(viewController: vc, presenter: presenter)
    }
    
}
