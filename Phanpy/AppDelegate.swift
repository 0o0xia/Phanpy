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
                    $0.tabBarItem = UITabBarItem(
                        title: "Timeline",
                        image: UIImage(named: "Local"),
                        selectedImage: nil
                    )
                }),
                UINavigationController(rootViewController: SettingsViewController().then {
                    $0.title = "Settings"
                    $0.tabBarItem = UITabBarItem(
                        title: "Settings",
                        image: UIImage(named: "Settings"),
                        selectedImage: nil
                    )
                }),
            ]
            return tabBarController
        }()

        window?.tintColor = AppSettings.shared.themeColor

        window?.makeKeyAndVisible()
        return true
    }
}
