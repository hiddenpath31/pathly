//
//  AppCoordinator.swift
//  pathly-vpn
//
//  Created by Александр on 07.11.2024.
//

import Foundation
import UIKit
import SkarbSDK
import Combine

class AppCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    var storageService: StorageServiceInterface
    let apiService = APINetworkService()
    let storeService = StoreService()
    
    var isDeeplinkOpened: Bool = false
    var isAppActive: Bool = false
    var isDataConversionSended: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    private var splashPresenter: SplashPresenterInterface?
    
    init(navigationController: UINavigationController, storageService: StorageServiceInterface) {
        self.navigationController = navigationController
        self.storageService = storageService
    }
        
    func start() {
        let paywall = self.storageService.remoteRespone?.paywall ?? PaywallLocalize()
        self.storeService.update(paywall: paywall)
        self.showSplashFlow(completion: { [weak self] mode in
            
            switch mode {
                case .organic:
                    self?.showOrganic()
            }

        })
    }
    
    private func showOrganic() {
        if self.storageService.isOnboardingShowed == false {
            self.storageService.isOnboardingShowed = true
            self.showOnboard()
        } else {
            self.showTab(autoConnect: false)
            if self.storeService.hasUnlockedPro == false && self.isDeeplinkOpened == false {
                self.showPaywall()
            }
        }
    }
    
    func receiveBranchParams(_ parameters: [String: AnyObject]) {
        
        let appsFlyerFormatData = SkarbSDK.convertConversionInfoToAppsFlyerFormat(parameters)
        if self.isDataConversionSended == false {
            SkarbSDK.sendSource(broker: .appsflyer, features: appsFlyerFormatData, brokerUserID: nil)
            AnalyticsValues.conversionInfo = appsFlyerFormatData
            self.isDataConversionSended = true
        }
        
        if self.isAppActive == true {
            return
        }
        
        guard self.isDeeplinkOpened == false else {
            return
        }
                        
        if self.storageService.isLastLaunch == false {
            let parameters = AnalyticsValues.conversionInfo
            let requestData = EventRequest(
                api_key: Constants.apiKey,
                event: .install,
                product: nil,
                af_data: parameters
            )
            self.apiService.application.sendEvent(requestData: requestData)            
        }
        
        self.splashPresenter?.showOrganic()
        self.isAppActive = true
        SkarbSDK.sendTest(name: "organic", group: "")
    }
    
    private func showOnboard() {
        let onboardCoordinator = OnboardCoordinator(navigationController: self.navigationController)
        onboardCoordinator.start()
        onboardCoordinator.didFinish = { [weak self] in
            self?.removeChildCoordinator(onboardCoordinator)
            self?.showTab(autoConnect: false)
            if self?.storeService.hasUnlockedPro == false {
                self?.showPaywall()
            }
        }
        self.addChildCoordinator(onboardCoordinator)
    }
    
    private func showPaywall() {
        let dismissDelay = self.storageService.remoteRespone?.dismissDelay ?? 0
        let components = PaywallComponents.make(
            storeService: self.storeService, 
            apiService: self.apiService, 
            storageService: self.storageService,
            type: .single(dismissDelay: dismissDelay)
        )
        components.viewController.modalPresentationStyle = .overCurrentContext
        self.navigationController.present(components.viewController, animated: true)
    }
    
    private func showTab(autoConnect: Bool) {
        let tabCoordinator = TabCoordinator(
            navigationController: self.navigationController,
            storageService: self.storageService,
            storeService: self.storeService, 
            apiService: self.apiService,
            autoConnect: autoConnect
        )
        tabCoordinator.start()
        self.addChildCoordinator(tabCoordinator)
    }

    func finish() {
        
    }
}

extension AppCoordinator {
    
    func showSplashFlow(completion: ((SplashMode) -> Void)?) {
        var splashComponents = SplashComponents.make(
            apiService: apiService,
            storageService: storageService,
            storeService: storeService
        )
        self.splashPresenter = splashComponents.presenter
        splashComponents.presenter.didLoadFinish = completion
        
        DispatchQueue.main.async {
            self.navigationController.setViewControllers([splashComponents.viewController], animated: false)
        }
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
