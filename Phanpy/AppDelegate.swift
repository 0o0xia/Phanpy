//
//  AppDelegate.swift
//  Phanpy
//
//  Created by 李孛 on 2018/12/8.
//

import MastodonKit
import UIKit

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
                    let viewController = HomeViewController()
                    viewController.title = "Home"
                    viewController.tabBarItem = UITabBarItem(
                        title: viewController.title,
                        image: UIImage(named: "Home"),
                        selectedImage: nil
                    )
                    return viewController
                }()),
                UINavigationController(rootViewController: TimelineViewController().then {
                    $0.title = "Timeline"
                    $0.tabBarItem = UITabBarItem(
                        title: $0.title,
                        image: UIImage(named: "LocalTimeline"),
                        selectedImage: nil
                    )
                }),
            ]
            return tabBarController
        }()
        window?.makeKeyAndVisible()
        return true
    }
}
