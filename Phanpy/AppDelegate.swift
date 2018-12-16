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
                UINavigationController(rootViewController: {
                    let viewController = TimelineTableViewController(
                        refreshRequest: Timelines.public(local: true, range: .default),
                        loadMoreRequestMaker: {
                            Timelines.public(local: true, range: .max(id: $0.id, limit: nil))
                        }
                    )
                    viewController.title = "Local Timeline"
                    viewController.tabBarItem = UITabBarItem(
                        title: viewController.title,
                        image: UIImage(named: "LocalTimeline"),
                        selectedImage: nil
                    )
                    return viewController
                }()),
                UINavigationController(rootViewController: {
                    let viewController = TimelineTableViewController(
                        refreshRequest: Timelines.public(),
                        loadMoreRequestMaker: {
                            Timelines.public(local: false, range: .max(id: $0.id, limit: nil))
                        }
                    )
                    viewController.title = "Federated Timeline"
                    viewController.tabBarItem = UITabBarItem(
                        title: viewController.title,
                        image: UIImage(named: "FederatedTimeline"),
                        selectedImage: nil
                    )
                    return viewController
                }()),
            ]
            return tabBarController
        }()
        window?.makeKeyAndVisible()
        return true
    }
}
