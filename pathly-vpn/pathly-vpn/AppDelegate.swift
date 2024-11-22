//
//  AppDelegate.swift
//  pathly-vpn
//
//  Created by Александр on 07.11.2024.
//

import UIKit
import FirebaseCore
import BranchSDK
import SkarbSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var appCoordinator: AppCoordinator?
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        SkarbSDK.initialize(clientId: "pathly", isObservable: true)
        
        let navigationController = UINavigationController()
        navigationController.setNavigationBarHidden(true, animated: false)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let storageService: StorageServiceInterface = StorageService()
        let appCoordinator = AppCoordinator(
            navigationController: navigationController,
            storageService: storageService
        )
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        self.appCoordinator = appCoordinator
        self.setupApperance()
        
#if DEBUG
        Branch.setUseTestBranchKey(true)
        Branch.setBranchKey("key_test_jul0iZu039VnRxXkH6kJKepgACghJyOO")
#endif
        
        storageService.loadRemoteKeys(completion: { [weak self] in
            self?.appCoordinator?.start()

            Branch.getInstance().initSession(launchOptions: launchOptions) { (params, error) in
                print(params as? [String: AnyObject] ?? {})
                
                if let error = error {
                    print("Branch initialization error: \(error.localizedDescription)")
                    return
                }
                
                if let params = params as? [String: AnyObject] {
                    self?.appCoordinator?.receiveBranchParams(params)
                }
            }
        })
        
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

extension AppDelegate {
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        Branch.getInstance().application(app, open: url, options: options)
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        // Handler for Universal Links
        Branch.getInstance().continue(userActivity)
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // Handler for Push Notifications
        Branch.getInstance().handlePushNotification(userInfo)
    }
    
}
