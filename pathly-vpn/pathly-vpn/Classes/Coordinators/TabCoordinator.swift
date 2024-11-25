//
//  TabCoordinator.swift
//  pathly-vpn
//
//  Created by Александр on 07.11.2024.
//

import Foundation
import UIKit

class TabCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    private var storageService: StorageServiceInterface
    private var storeService: StoreServiceInterface
    private var apiService: APINetworkServiceInterface
    private var autoConnect: Bool
    private var vpnComponents: VPNComponents?
    var didLogout: Completion?
        
    private lazy var tabbarControler: UITabBarController = {
        var tabController = UITabBarController()
        return tabController
    }()
    
    init(navigationController: UINavigationController, storageService: StorageServiceInterface, storeService: StoreServiceInterface, apiService: APINetworkServiceInterface, autoConnect: Bool) {
        self.navigationController = navigationController
        self.storeService = storeService
        self.storageService = storageService
        self.apiService = apiService
        self.autoConnect = autoConnect
        self.setupUI()
    }
    
    private func setupUI() {
        
    }
    
    func start() {
        self.navigationController.setViewControllers([self.tabbarControler], animated: true)
        
        let dataNavigationController: UINavigationController = {
            let dataComponents = DataComponents.make(apiService: self.apiService)
            let navController = TabNavigationController(
                tab: .data,
                root: dataComponents.viewController
            )
            return navController
        }()
        let vpnNavigationController: UINavigationController = {
            let vpnComponents = VPNComponents.make(
                storageService: storageService,
                apiServer: apiService, 
                storeService: storeService
            )
            let navController = TabNavigationController(
                tab: .vpn,
                root: vpnComponents.viewController
            )
            vpnComponents.presenter.didShowCountry = { [weak self] in
                self?.showLocations(navigationController: navController)
            }
            self.vpnComponents = vpnComponents
            return navController
        }()
        let settingsNavigationController: UINavigationController = {
            let settingsComponents = SettingsComponents.make(
                storeService: self.storeService, 
                storageService: self.storageService
            )
            let navController = TabNavigationController(
                tab: .settings,
                root: settingsComponents.viewController
            )
            return navController
        }()
        setupNavigationBar(navigationController: settingsNavigationController)
        
        self.tabbarControler.setViewControllers(
            [dataNavigationController,
             vpnNavigationController,
             settingsNavigationController],
            animated: false
        )
        self.tabbarControler.tabBar.backgroundColor = .white
        self.tabbarControler.selectedIndex = 1
        
        if autoConnect == true {
            self.storageService.isPrivacyShowed = true
            self.autoConnect = false
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                self.vpnComponents?.presenter.powerDidTap()
            }
        } else {
            self.showPrivacyIfNeeded(navigationController: vpnNavigationController)
        }
    }
    
    private func setupNavigationBar(navigationController: UINavigationController) {
        let appearance = UINavigationBarAppearance()
        
        let backImage = Asset.back.image.withRenderingMode(.alwaysTemplate)
        appearance.setBackIndicatorImage(backImage, transitionMaskImage: backImage)
        appearance.titleTextAttributes = [
            NSAttributedString.Key.font: FontFamily.SFProText.semibold.font(size: 20),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = Asset.backgroundColor.color
        appearance.shadowColor = .clear
        UINavigationBar.appearance().barTintColor = UIColor(.white)
        
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func showPrivacyIfNeeded(navigationController: UINavigationController) {
        if self.storageService.isPrivacyShowed == false {
            self.storageService.isPrivacyShowed = true
            let privacyVC = PrivacyViewController()
            privacyVC.hidesBottomBarWhenPushed = true
            privacyVC.didDismiss = { [weak self] in
                if self?.autoConnect == true {
                    self?.autoConnect = false
                    self?.vpnComponents?.presenter.powerDidTap()
                }
            }
            navigationController.pushViewController(privacyVC, animated: true)
        }
    }
    
    private func showLocations(navigationController: UINavigationController) {
        let locationComponents = LocationsComponents.make(
            storageService: storageService,
            storeService: storeService
        )
        locationComponents.viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(
            locationComponents.viewController,
            animated: true
        )
    }
    
    func finish() {
        //
    }
    
    func applicationHandlerEvent(_ event: ApplicationEvent) {
        //
    }
    
    
    
}

