//
//  AppCoordinator.swift
//  pathly-vpn
//
//  Created by Александр on 07.11.2024.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    let storageService = StorageService()
    let apiService = APINetworkService()
    let storeService = StoreService()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
        
    func start() {
        self.showSplashFlow(completion: {
            if self.storageService.isOnboardingShowed == false {
                self.storageService.isOnboardingShowed = true
                self.showOnboard()
            } else {
                self.showTab()
                if self.storeService.hasUnlockedPro == false {
                    self.showPaywall()
                }
            }
        })
    }
    
    private func showOnboard() {
        let onboardCoordinator = OnboardCoordinator(navigationController: self.navigationController)
        onboardCoordinator.start()
        onboardCoordinator.didFinish = { [weak self] in
            self?.removeChildCoordinator(onboardCoordinator)
            self?.showTab()
            if self?.storeService.hasUnlockedPro == false {
                self?.showPaywall()
            }
        }
        self.addChildCoordinator(onboardCoordinator)
    }
    
    private func showPaywall() {
        let components = PaywallComponents.make(storeService: self.storeService, type: .single)
        components.viewController.modalPresentationStyle = .overCurrentContext
        self.navigationController.present(components.viewController, animated: true)
    }
    
    private func showTab() {
        let tabCoordinator = TabCoordinator(
            navigationController: self.navigationController,
            storageService: self.storageService,
            storeService: self.storeService, 
            apiService: self.apiService
        )
        tabCoordinator.start()
        self.addChildCoordinator(tabCoordinator)
    }

    func finish() {
        
    }
}

extension AppCoordinator {
    
    func showSplashFlow(completion: Completion?) {
        var splashComponents = SplashComponents.make(
            apiService: apiService,
            storageService: storageService
        )
        splashComponents.presenter.didFinish = completion
        self.navigationController.setViewControllers([splashComponents.viewController], animated: false)
    }

}

extension AppCoordinator {
    
    func applicationHandlerEvent(_ event: ApplicationEvent) {
        self.childCoordinators.forEach { coordinator in
            coordinator.applicationHandlerEvent(event)
            coordinator.childCoordinators.forEach { coordinator in
                coordinator.applicationHandlerEvent(event)
            }
        }
    }

}
