//
//  Setting.swift
//  Phanpy
//
//  Created by 邵景添 on 2018/12/28.
//

import UIKit

protocol Settingable {
    var title: String { get }
    var icon: UIImage? { get }
    var type: SettingType { get }
    var selectedHandler: ((Settingable, SettingCellable) -> Void)? { get }
}

struct Setting: Settingable {
    var title: String
    var icon: UIImage?
    var type: SettingType
    var selectedHandler: ((Settingable, SettingCellable) -> Void)?

    init(title: String, type: SettingType, icon: UIImage?) {
        self.title = title
        self.type = type
        self.icon = icon
    }
}
