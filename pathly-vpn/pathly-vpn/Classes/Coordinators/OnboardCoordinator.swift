//
//  OnboardCoordinator.swift
//  pathly-vpn
//
//  Created by Александр on 07.11.2024.
//

import UIKit

class OnboardCoordinator: Coordinator {
    
    var didFinish: Completion?
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let onboardComponents = OnboardComponents.make()
        onboardComponents.presenter.didFinish = { [weak self] in
            self?.didFinish?()
        }
        self.navigationController.pushViewController(onboardComponents.viewController, animated: true)
//        self.showSplashFlow()
    }
    
    func finish() {
        
    }
}

extension OnboardCoordinator {
    
    func applicationHandlerEvent(_ event: ApplicationEvent) {
        self.childCoordinators.forEach { coordinator in
            coordinator.applicationHandlerEvent(event)
            coordinator.childCoordinators.forEach { coordinator in
                coordinator.applicationHandlerEvent(event)
            }
        }
    }

}
