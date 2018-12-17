//
//  HomeViewController.swift
//  Phanpy
//
//  Created by 李孛 on 2018/12/11.
//

import MastodonKit
import UIKit

final class HomeViewController: UIViewController {
    private let timelineTableViewController = TimelineTableViewController(
        refreshRequest: Timelines.home(),
        loadMoreRequestMaker: { Timelines.home(range: .max(id: $0.id, limit: nil)) }
    )
        .then { $0.client.accessToken = UserDefaults.standard.string(forKey: "me.libei.Phanpy.access-token") }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addAccessToken)
        )

        addChild(timelineTableViewController)
        view.addSubview(timelineTableViewController.view)
        timelineTableViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            timelineTableViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            timelineTableViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            timelineTableViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            timelineTableViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        timelineTableViewController.didMove(toParent: self)
    }

    @objc
    private func addAccessToken() {
        let alertController = UIAlertController(title: "🎺", message: nil, preferredStyle: .alert)
        alertController.addTextField()
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Add", style: .default, handler: { _ in
            self.timelineTableViewController.client.accessToken = alertController.textFields?.first?.text
            UserDefaults.standard.set(
                self.timelineTableViewController.client.accessToken,
                forKey: "me.libei.Phanpy.access-token"
            )
        }))
        present(alertController, animated: true)
    }
}
