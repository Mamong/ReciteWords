//
//  AppDelegate.swift
//  ReciteWords
//
//  Created by mac on 2021/9/20.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
//    var window: UIWindow?
//
//    lazy var mainTabBarVC: UITabBarController = {
//        let mainvc = UITabBarController.init()
//
//        let homevc = IndexViewController.init()
//        let myvc = MineViewController.init()
//
//        let homeNav = UINavigationController.init(rootViewController: homevc)
//        let myNav = UINavigationController.init(rootViewController: myvc)
//
//        mainvc.setViewControllers([homeNav, myNav], animated: true)
//
//        return mainvc
//    }()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        if #available(iOS 13, *) {
//
//        }else {
//
//            window = UIWindow(frame: UIScreen.main.bounds)
//            window?.backgroundColor = UIColor.white
//            window?.rootViewController = self.mainTabBarVC
//            window?.makeKeyAndVisible()
//        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

