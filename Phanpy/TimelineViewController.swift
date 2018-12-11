//
//  TimelineViewController.swift
//  Phanpy
//
//  Created by 李孛 on 2018/12/11.
//

import MastodonKit
import UIKit

class TimelineViewController: UIViewController {
    var client: Client
    private let request: Request<[Status]>

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

    // MARK: -

    init(client: Client = Client(baseURL: "https://mastodon.social"), request: Request<[Status]>) {
        self.client = client
        self.request = request
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    // MARK: -

    override func loadView() {
        view = tableView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        refresh()
    }

    @objc
    private func refresh() {
        client.run(request) { result in
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

    @objc
    private func loadMoreIfNeeded() {

    }
}

extension TimelineViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return statuses.count
        default:
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                    as? StatusTableViewCell
                else {
                    fatalError()
            }
            cell.status = statuses[indexPath.row]
            return cell

        default:
            let cell = UITableViewCell()
            let button = UIButton(type: .system)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(loadMoreIfNeeded), for: .touchUpInside)
            button.setTitle("Load More", for: .normal)
            cell.contentView.addSubview(button)
            NSLayoutConstraint.activate([
                button.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
                button.topAnchor.constraint(equalTo: cell.contentView.layoutMarginsGuide.topAnchor),
                button.bottomAnchor.constraint(equalTo: cell.contentView.layoutMarginsGuide.bottomAnchor),
            ])
            return cell
        }
    }
}

extension TimelineViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let textView = UITextView()
        textView.text = statuses[indexPath.row].content
        let viewController = UIViewController()
        viewController.view = textView
        navigationController?.pushViewController(viewController, animated: true)
    }
}
