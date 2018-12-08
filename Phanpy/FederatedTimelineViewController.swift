//
//  FederatedTimelineViewController.swift
//  Phanpy
//
//  Created by 李孛 on 2018/12/8.
//

import MastodonKit
import UIKit

final class FederatedTimelineViewController: UIViewController {

    private var statuses: [Status] = []

    @IBOutlet
    private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "FederatedTimeline"
        refresh()
    }

    private func refresh() {
        Client(baseURL: "https://mastodon.social").run(Timelines.public()) { result in
            switch result {
            case .success(let statuses, _):
                DispatchQueue.main.async {
                    self.statuses = statuses
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension FederatedTimelineViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statuses.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = statuses[indexPath.row].account.displayName
        return cell
    }
}
