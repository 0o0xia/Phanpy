//
//  SettingCell.swift
//  Phanpy
//
//  Created by 邵景添 on 2018/12/27.
//

import UIKit

class SettingCell: TableViewCell, SettingCellable {

    private var setting: Settingable?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    func bind(_ setting: Settingable) {
        self.setting = setting
        textLabel?.text = setting.title
        imageView?.image = setting.icon
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageView?.bounds.size = CGSize(width: 29, height: 29)
        imageView?.center.y = contentView.center.y
        imageView?.layer.cornerRadius = 6
        imageView?.layer.masksToBounds = true
    }
}

final class IndicatorSettingCell: SettingCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
    }
}

final class CheckSettingCell: SettingCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.accessoryType = selected ? .checkmark : .none
    }
}
