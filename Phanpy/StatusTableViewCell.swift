//
//  StatusTableViewCell.swift
//  Phanpy
//
//  Created by 李孛 on 2018/12/8.
//

import Kingfisher
import MastodonKit
import UIKit

final class StatusTableViewCell: UITableViewCell {
    var status: Status? {
        didSet {
            guard let status = status else {
                return
            }

            avatarImageView.kf.setImage(with: URL(string: status.account.avatarStatic))
        }
    }

    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(avatarImageView)
        NSLayoutConstraint.activate([
            avatarImageView.widthAnchor.constraint(equalToConstant: 50),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            avatarImageView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            avatarImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.layoutMarginsGuide.bottomAnchor),
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
