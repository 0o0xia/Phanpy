//
//  PublicTimelineViewController.swift
//  Phanpy
//
//  Created by 李孛 on 2018/12/8.
//

import MastodonKit
import UIKit

final class PublicTimelineViewController: UIViewController {
    var isLocal = true

    private var statuses: [Status] = []

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.refreshControl = {
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
            return refreshControl
        }()
        tableView.register(StatusTableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()

    override func loadView() {
        view = tableView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        refresh()
    }

    @objc
    private func refresh() {
        Client(baseURL: "https://mastodon.social").run(Timelines.public(local: isLocal, range: .default)) { result in
            switch result {
            case .success(let statuses, _):
                DispatchQueue.main.async {
                    self.statuses = statuses
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
            DispatchQueue.main.async {
                self.tableView.refreshControl?.endRefreshing()
            }
        }
    }
}

extension PublicTimelineViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statuses.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                as? StatusTableViewCell
        else {
            fatalError()
        }
        cell.status = statuses[indexPath.row]
        return cell
    }
}

extension PublicTimelineViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let textView = UITextView()
        textView.text = statuses[indexPath.row].content
        let viewController = UIViewController()
        viewController.view = textView
        navigationController?.pushViewController(viewController, animated: true)
    }
}
