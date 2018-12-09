//
//  AppDelegate.swift
//  Phanpy
//
//  Created by 李孛 on 2018/12/8.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        window = UIWindow()
        window?.rootViewController = {
            let tabBarController = UITabBarController()
            tabBarController.viewControllers = [
                UINavigationController(rootViewController: {
                    let viewController = PublicTimelineViewController()
                    viewController.title = "Local Timeline"
                    viewController.tabBarItem = UITabBarItem(
                        title: viewController.title,
                        image: UIImage(named: "LocalTimeline"),
                        selectedImage: nil
                    )
                    return viewController
                }()),
                UINavigationController(rootViewController: {
                    let viewController = PublicTimelineViewController()
                    viewController.isLocal = false
                    viewController.tabBarItem = UITabBarItem(
                        title: viewController.title,
                        image: UIImage(named: "FederatedTimeline"),
                        selectedImage: nil
                    )
                    viewController.title = "Federated Timeline"
                    return viewController
                }()),
            ]
            return tabBarController
        }()
        window?.makeKeyAndVisible()
        return true
    }
}
