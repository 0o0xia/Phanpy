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
        navigationItem.searchController = UISearchController(searchResultsController: nil)

        addChild(timelineTableViewController)
        view.addSubview(timelineTableViewController.view)
        timelineTableViewController.view.snp.makeConstraints { $0.edges.equalTo(view) }
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
