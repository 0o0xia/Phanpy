//
//  TimelineViewController.swift
//  Phanpy
//
//  Created by 李孛 on 2018/12/17.
//

import MastodonKit
import UIKit

final class TimelineViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = UISearchController(searchResultsController: nil)

        let localTimelineTableViewController = TimelineTableViewController(
            refreshRequest: Timelines.public(local: true, range: .default),
            loadMoreRequestMaker: { Timelines.public(local: true, range: .max(id: $0.id, limit: nil)) }
        )

        addChild(localTimelineTableViewController)
        view.addSubview(localTimelineTableViewController.view)
        localTimelineTableViewController.view.snp.makeConstraints { $0.edges.equalToSuperview() }
        localTimelineTableViewController.didMove(toParent: self)
    }
}
