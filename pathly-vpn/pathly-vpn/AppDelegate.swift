//
//  AppDelegate.swift
//  pathly-vpn
//
//  Created by Александр on 07.11.2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var appCoordinator: AppCoordinator?
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let navigationController = UINavigationController()
        navigationController.setNavigationBarHidden(true, animated: false)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let appCoordinator = AppCoordinator(navigationController: navigationController)
        appCoordinator.start()
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        self.appCoordinator = appCoordinator
        self.setupApperance()
        
        return true
    }
    
    private func setupApperance() {
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -10)
        
        let tabItemAppearance = UITabBarItemAppearance()
//        tabItemAppearance.normal.iconColor = Asset.for egroundPrimary900.color
        tabItemAppearance.normal.titleTextAttributes = [
            NSAttributedString.Key.font: Styles.Fonts.caption
//            NSAttributedString.Key.foregroundColor: Asset.foregroundPrimary900.color
        ]
        
//        tabItemAppearance.selected.iconColor = Asset.textBrandTertiary600.color
        tabItemAppearance.selected.titleTextAttributes = [
            NSAttributedString.Key.font: Styles.Fonts.caption
//            NSAttributedString.Key.foregroundColor: Asset.textBrandTertiary600.color
        ]
        
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = Asset.gray.color
        
        tabBarAppearance.inlineLayoutAppearance = tabItemAppearance
        tabBarAppearance.stackedLayoutAppearance = tabItemAppearance
        tabBarAppearance.compactInlineLayoutAppearance = tabItemAppearance
        
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white,
                                          .font: Styles.Fonts.title]
        appearance.backgroundColor = Asset.backgroundColor.color
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().tintColor = .white
                
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }

}

