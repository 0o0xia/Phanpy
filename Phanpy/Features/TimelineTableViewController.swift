//
//  TimelineTableViewController.swift
//  Phanpy
//
//  Created by 李孛 on 2018/12/11.
//

import MastodonKit
import UIKit

final class TimelineTableViewController: UIViewController {
    var client: Client
    private let refreshRequest: Request<[Status]>
    private let loadMoreRequestMaker: (_ lastStatus: Status) -> Request<[Status]>

    private var statuses: [Status] = []

    private lazy var tableView = UITableView().then {
        $0.cellLayoutMarginsFollowReadableWidth = true
        $0.dataSource = self
        $0.delegate = self
        $0.refreshControl = {
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
            return refreshControl
        }()
        StatusTableViewCellReuseIdentifier.register(for: $0)
    }

    private var isLoadingMore = false

    // MARK: -

    init(
        client: Client = Client(baseURL: "https://mastodon.social"),
        refreshRequest: Request<[Status]>,
        loadMoreRequestMaker: @escaping (_ lastStatus: Status) -> Request<[Status]>
    ) {
        self.client = client
        self.refreshRequest = refreshRequest
        self.loadMoreRequestMaker = loadMoreRequestMaker
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

    // MARK: -

    @objc
    private func refresh() {
        client.run(refreshRequest) { result in
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
        guard !isLoadingMore, let lastStatus = statuses.last else {
            return
        }
        isLoadingMore = true
        client.run(loadMoreRequestMaker(lastStatus)) { [weak self] result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }

                self.isLoadingMore = false
                switch result {
                case .success(let newStatuses, _):
                    let indexPaths = newStatuses.enumerated().map({
                        IndexPath(row: self.statuses.count + $0.offset, section: 0)
                    })
                    self.statuses.append(contentsOf: newStatuses)
                    UIView.performWithoutAnimation {
                        self.tableView.insertRows(at: indexPaths, with: .none)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}

extension TimelineTableViewController: UITableViewDataSource {
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
            let status = statuses[indexPath.row]
            let cell: StatusBindableTableViewCell = tableView.dequeueReusableCell(
                withIdentifier: StatusTableViewCellReuseIdentifier(status: status).rawValue,
                for: indexPath
            )
            cell.bind(status)
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

import SafariServices

extension TimelineTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        switch indexPath.section {
        case 0:
            let status = statuses[indexPath.row]
            guard let url = status.url else {
                break
            }
            let safariViewController = SFSafariViewController(url: url)
            present(safariViewController, animated: true)
        default:
            loadMoreIfNeeded()
        }
    }
}
