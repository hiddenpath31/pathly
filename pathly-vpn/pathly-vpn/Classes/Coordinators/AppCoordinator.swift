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
        self.showSplashFlow(completion: { [weak self] mode in
            
            switch mode {
                case .organic:
                    self?.showOrganic()
                case .funnel(let flow):
                    self?.showFunnel(type: flow)
            }

        })
    }
    
    private func showOrganic() {
        if self.storageService.isOnboardingShowed == false {
            self.storageService.isOnboardingShowed = true
            self.showOnboard()
        } else {
            self.showTab(autoConnect: false)
            if self.storeService.hasUnlockedPro == false {
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
        
        if let params = parameters as? [String: AnyObject] {
            // получениe данных из params
            var params = params
            
            if let referrer = params["appkey"] as? String {
                print("Referrer: \(referrer)")
                
                let keys = self.storageService.remoteRespone?.keys ?? []
                if keys.contains(referrer), referrer == "checkFlow", let checkFlow = self.storageService.remoteRespone?.checkFlow, self.storageService.isFunnelShowed == false {
                    self.isDeeplinkOpened = true
                    self.storageService.isFunnelShowed = true
                    self.splashPresenter?.showFunnel(type: .flow1(model: checkFlow))
                    SkarbSDK.sendTest(name: "checkFlow", group: "")
                } else if keys.contains(referrer), referrer == "scanFlow", let scanFlow = self.storageService.remoteRespone?.scanFlow, self.storageService.isFunnelShowed == false {
                    self.isDeeplinkOpened = true
                    self.storageService.isFunnelShowed = true
                    SkarbSDK.sendTest(name: "scanFlow", group: "")
                    self.splashPresenter?.showFunnel(type: .flow2(model: scanFlow))
                } else {
                    self.splashPresenter?.showOrganic()
                    self.isAppActive = true
                    SkarbSDK.sendTest(name: "organic", group: "")
                    return
                }
                
            } else {
                self.splashPresenter?.showOrganic()
                self.isAppActive = true

                return
            }
            
        }
        
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
    
    func showFunnel(type: FunnelFlowType) {
//        let loaderViewController = FunnelLoaderViewController()
        
        let funnelCoordinator = FunnelCoordinator(
            navigationController: navigationController,
            flowType: type,
            storeService: self.storeService,
            apiService: self.apiService
        )
        funnelCoordinator.delegate = self
        addChildCoordinator(funnelCoordinator)
        funnelCoordinator.start()
        
//        self.navigationController.setViewControllers([loaderViewController], animated: false)
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

extension AppCoordinator: FunnelCoordinatorDelegate {
    
    func funnelCoordinatorDidEnterBackground(coordinator: FunnelCoordinator) {
        self.removeChildCoordinator(coordinator)
        self.showOrganic()
    }
    
    func funnelCoordinatorDidCaptureScreen(coordinator: FunnelCoordinator) {
        self.removeChildCoordinator(coordinator)
        self.showOrganic()
    }
    
    func funnelCoordinatorDidEndFlow(coordinator: FunnelCoordinator) {
        self.storageService.isOnboardingShowed = true
        self.removeChildCoordinator(coordinator)
        self.showTab(autoConnect: true)
    }

}
