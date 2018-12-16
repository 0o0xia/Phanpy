//
//  HomeViewController.swift
//  Phanpy
//
//  Created by 李孛 on 2018/12/11.
//

import MastodonKit
import UIKit

final class HomeViewController: TimelineViewController {
    init() {
        super.init(refreshRequest: Timelines.home(), loadMoreRequestMaker: {
            Timelines.home(range: .max(id: $0.id, limit: nil))
        })
        client.accessToken = UserDefaults.standard.string(forKey: "me.libei.Phanpy.access-token")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addAccessToken)
        )
        navigationItem.searchController = UISearchController(searchResultsController: nil)
    }

    @objc
    private func addAccessToken() {
        let alertController = UIAlertController(title: "🎺", message: nil, preferredStyle: .alert)
        alertController.addTextField()
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Add", style: .default, handler: { _ in
            self.client.accessToken = alertController.textFields?.first?.text
            UserDefaults.standard.set(self.client.accessToken, forKey: "me.libei.Phanpy.access-token")
        }))
        present(alertController, animated: true)
    }
}
