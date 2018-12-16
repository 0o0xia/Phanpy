//
//  BlankViewController.swift
//  Phanpy
//
//  Created by 李孛 on 2018/12/10.
//

import UIKit

final class BlankViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        let label = UILabel().then {
            $0.numberOfLines = 0
            $0.text = "This page is intentionally left blank."
            $0.textAlignment = .center
        }

        view.addSubview(label)
        label.snp.makeConstraints {
            $0.leading.equalTo(view.snp.leadingMargin)
            $0.trailing.equalTo(view.snp.trailingMargin)
            $0.centerY.equalTo(view.snp.centerY)
        }
    }
}
