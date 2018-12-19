//
//  StatusTableViewCell.swift
//  Phanpy
//
//  Created by 李孛 on 2018/12/8.
//

import MastodonKit
import UIKit

enum StatusTableViewCellReuseIdentifier: String {
    case `default` = "StatusTableViewCell.default"
    case previewImage = "StatusTableViewCell.previewImage"

    init(status: Status) {
        if status.mediaAttachments.isEmpty {
            self = .default
        } else {
            self = .previewImage
        }
    }
}

extension StatusTableViewCellReuseIdentifier {
    static func register(for tableView: UITableView) {
        tableView.register(DefaultStatusTableViewCell.self, forCellReuseIdentifier: self.default.rawValue)
        tableView.register(PreviewImageStatusTableViewCell.self, forCellReuseIdentifier: self.previewImage.rawValue)
    }
}

// MARK: -

fileprivate final class DefaultStatusTableViewCell: TableViewCell, StatusBindable {
    private let statusView = StatusView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        statusView.do {
            contentView.addSubview($0)
            NSLayoutConstraint.activate([
                $0.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
                $0.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
                $0.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
                $0.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            ])
        }
    }

    func bind(_ status: Status) {
        statusView.status = status
    }
}

// MARK: -

fileprivate final class PreviewImageStatusTableViewCell: TableViewCell, StatusBindable {
    private let statusView = StatusView()

    private let previewImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        statusView.do {
            contentView.addSubview($0)
            NSLayoutConstraint.activate([
                $0.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
                $0.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
                $0.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            ])
        }
        previewImageView.do {
            contentView.addSubview($0)
            NSLayoutConstraint.activate([
                $0.heightAnchor.constraint(equalTo: $0.widthAnchor, multiplier: 9.0 / 16.0),
                $0.leadingAnchor.constraint(equalTo: statusView.contentTextView.leadingAnchor),
                $0.trailingAnchor.constraint(equalTo: statusView.trailingAnchor),
                $0.topAnchor.constraint(equalTo: statusView.bottomAnchor),
                $0.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            ])
        }
    }

    func bind(_ status: Status) {
        guard let attachment = status.mediaAttachments.first else {
            fatalError()
        }

        statusView.status = status
        previewImageView.kf.setImage(with: URL(string: attachment.previewURL))
    }
}

// MARK: -

fileprivate final class StatusContentTextView: UITextView {
    override var canBecomeFirstResponder: Bool {
        return false
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

        guard characterIndex >= 0 && characterIndex < textStorage.length else {
            return nil
        }

        if textStorage.attribute(.link, at: characterIndex, effectiveRange: nil) == nil {
            return nil
        } else {
            return self
        }
    }
}

fileprivate final class StatusView: UIView {
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

    private let avatarImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 25
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private let nameLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setContentCompressionResistancePriority(.required, for: .vertical)
        $0.setContentHuggingPriority(.required, for: .vertical)
    }

    private let timeLabel = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .subheadline)
        $0.textColor = .gray
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
        $0.setContentHuggingPriority(.required, for: .horizontal)
    }

    let contentTextView = StatusContentTextView().then {
        $0.isEditable = false
        $0.isScrollEnabled = false
        $0.textContainer.lineFragmentPadding = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setContentCompressionResistancePriority(.required, for: .vertical)
        $0.setContentHuggingPriority(.required, for: .vertical)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        translatesAutoresizingMaskIntoConstraints = false

        addSubview(avatarImageView)
        addSubview(nameLabel)
        addSubview(timeLabel)
        addSubview(contentTextView)

        setUpConstraints()
    }

    private func setUpConstraints() {
        avatarImageView.do {
            NSLayoutConstraint.activate([
                $0.widthAnchor.constraint(equalToConstant: $0.layer.cornerRadius * 2),
                $0.heightAnchor.constraint(equalTo: $0.widthAnchor),
                $0.leadingAnchor.constraint(equalTo: leadingAnchor),
                $0.topAnchor.constraint(equalTo: topAnchor),
                $0.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
            ])
        }
        nameLabel.do {
            NSLayoutConstraint.activate([
                $0.leadingAnchor.constraint(
                    equalToSystemSpacingAfter: avatarImageView.trailingAnchor,
                    multiplier: 1
                ),
                $0.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
            ])
        }
        timeLabel.do {
            NSLayoutConstraint.activate([
                $0.firstBaselineAnchor.constraint(equalTo: nameLabel.firstBaselineAnchor),
                $0.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
                $0.trailingAnchor.constraint(equalTo: trailingAnchor),
            ])
        }
        contentTextView.do {
            NSLayoutConstraint.activate([
                $0.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
                $0.trailingAnchor.constraint(equalTo: timeLabel.trailingAnchor),
                $0.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
                $0.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
            ])
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}