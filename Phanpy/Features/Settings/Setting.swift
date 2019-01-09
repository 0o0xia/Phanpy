//
//  Setting.swift
//  Phanpy
//
//  Created by 邵景添 on 2018/12/28.
//

import UIKit

protocol SettingItem {
    var title: String { get }
    var icon: UIImage? { get }
    var selectedHandler: ((SettingItem) -> Void)? { get }
}

struct Setting: SettingItem {
    var title: String
    var icon: UIImage?
    var selectedHandler: ((SettingItem) -> Void)?

    init(title: String, icon: UIImage?) {
        self.title = title
        self.icon = icon
    }
}
