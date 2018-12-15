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
                        .foregroundColor: UIColor.gray,
                    ]
                ))
                return attributedString
            }()
            timeLabel.text = status.createdAt.shortTimeAgoSinceNow
            contentTextView.attributedText = StatusContentParser(content: status.content).parse()
        }
    }

    // MARK: -

    private let avatarImageView = UIImageView {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 25
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private let nameLabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setContentCompressionResistancePriority(.required, for: .vertical)
        $0.setContentHuggingPriority(.required, for: .vertical)
    }

    private let timeLabel = UILabel {
        $0.font = .preferredFont(forTextStyle: .subheadline)
        $0.textColor = .gray
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
        $0.setContentHuggingPriority(.required, for: .horizontal)
    }

    private let contentTextView = ContentTextView()

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

// MARK: - StatusTableViewCell.ContentTextView

extension StatusTableViewCell {
    private final class ContentTextView: UITextView {
        override var canBecomeFirstResponder: Bool {
            return false
        }

        init() {
            super.init(frame: .zero, textContainer: nil)
            isEditable = false
            isScrollEnabled = false
            textContainer.lineFragmentPadding = 0
            textContainerInset = .zero
            translatesAutoresizingMaskIntoConstraints = false
            setContentCompressionResistancePriority(.required, for: .vertical)
            setContentHuggingPriority(.required, for: .vertical)
        }

        override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
            var location = point
            location.x -= textContainerInset.left
            location.y -= textContainerInset.top

            let characterIndex = layoutManager.characterIndex(
                for: location,
                in: textContainer,
                fractionOfDistanceBetweenInsertionPoints: nil
            )

            if textStorage.attribute(.link, at: characterIndex, effectiveRange: nil) == nil {
                return nil
            } else {
                return self
            }
        }

        @available(*, unavailable)
        required init?(coder aDecoder: NSCoder) {
            fatalError()
        }
    }
}
