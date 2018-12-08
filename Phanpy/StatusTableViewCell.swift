//
//  StatusTableViewCell.swift
//  Phanpy
//
//  Created by 李孛 on 2018/12/8.
//

import DateToolsSwift
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
            nameLabel.attributedText = {
                let attributedString = NSMutableAttributedString()
                if !status.account.displayName.isEmpty {
                    attributedString.append(NSAttributedString(
                        string: status.account.displayName,
                        attributes: [.font: UIFont.preferredFont(forTextStyle: .headline)]
                    ))
                    attributedString.append(NSAttributedString(string: " "))
                }
                attributedString.append(NSAttributedString(
                    string: "@\(status.account.acct)",
                    attributes: [
                        .font: UIFont.preferredFont(forTextStyle: .subheadline),
                        .foregroundColor: UIColor.darkGray,
                    ]
                ))
                return attributedString
            }()
            timeLabel.text = status.createdAt.shortTimeAgoSinceNow
        }
    }

    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(avatarImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(timeLabel)

        setUpConstraints()
    }

    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            avatarImageView.widthAnchor.constraint(equalToConstant: 50),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            avatarImageView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            avatarImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.layoutMarginsGuide.bottomAnchor),
        ])
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(
                equalToSystemSpacingAfter: avatarImageView.trailingAnchor,
                multiplier: 1
            ),
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
        ])
        NSLayoutConstraint.activate([
            timeLabel.firstBaselineAnchor.constraint(equalTo: nameLabel.firstBaselineAnchor),
            timeLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
        ])
    }

    // MARK: -

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
