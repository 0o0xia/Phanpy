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
            contentTextView.attributedText = StatusContentParser(content: status.content).output
        }
    }

    // MARK: -

    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        return imageView
    }()

    private let nameLabel = UILabel()

    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .gray
        return label
    }()

    private let contentTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.textContainer.lineFragmentPadding = 0
        return textView
    }()

    // MARK: -

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(avatarImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(contentTextView)

        setUpConstraints()
    }

    private func setUpConstraints() {
        avatarImageView.layer.cornerRadius = 5
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarImageView.widthAnchor.constraint(equalToConstant: 50),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            avatarImageView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            avatarImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.layoutMarginsGuide.bottomAnchor),
        ])
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(
                equalToSystemSpacingAfter: avatarImageView.trailingAnchor,
                multiplier: 1
            ),
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
        ])
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        timeLabel.setContentHuggingPriority(.required, for: .horizontal)
        NSLayoutConstraint.activate([
            timeLabel.firstBaselineAnchor.constraint(equalTo: nameLabel.firstBaselineAnchor),
            timeLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
        ])
        contentTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentTextView.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            contentTextView.trailingAnchor.constraint(equalTo: timeLabel.trailingAnchor),
            contentTextView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            contentTextView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.layoutMarginsGuide.bottomAnchor),
        ])
    }

    // MARK: -

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
