//
//  TimelineViewController.swift
//  Phanpy
//
//  Created by 李孛 on 2018/12/17.
//

import MastodonKit
import UIKit

final class TimelineViewController: UIViewController {
    private let localTimelineTableViewController = TimelineTableViewController(
        refreshRequest: Timelines.public(local: true, range: .default),
        loadMoreRequestMaker: { Timelines.public(local: true, range: .max(id: $0.id, limit: nil)) }
    )

    private let federatedTimelineTableViewController = TimelineTableViewController(
        refreshRequest: Timelines.public(),
        loadMoreRequestMaker: { Timelines.public(local: false, range: .max(id: $0.id, limit: nil)) }
    )

    private var currentTimelineTableViewController: TimelineTableViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.titleView = UISegmentedControl(items: ["Local", "Federated"]).then {
            $0.selectedSegmentIndex = 0
            $0.addTarget(self, action: #selector(changeTimeline(_:)), for: .valueChanged)
            changeTimeline($0)
        }
    }

    @objc
    private func changeTimeline(_ sender: UISegmentedControl) {
        if let viewController = currentTimelineTableViewController {
            viewController.willMove(toParent: nil)
            viewController.view.removeFromSuperview()
            viewController.removeFromParent()
        }

        let viewController = sender.selectedSegmentIndex == 0
            ? localTimelineTableViewController
            : federatedTimelineTableViewController

        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.view.snp.makeConstraints { $0.edges.equalToSuperview() }
        viewController.didMove(toParent: self)

        currentTimelineTableViewController = viewController
    }
}
