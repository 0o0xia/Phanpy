//
//  ThemeSettingsViewController.swift
//  Phanpy
//
//  Created by 邵景添 on 2018/12/26.
//

import UIKit

private struct TintSetting: Settingable {
    var title: String
    var icon: UIImage?
    var color: Color
    var type: SettingType
    var selectedHandler: ((Settingable, SettingCellable) -> Void)?

    init(title: String, color: Color, type: SettingType) {
        self.title = title
        self.icon = UIImage(color: color.color,
                            size: CGSize(width: 29, height: 29))
        self.color = color
        self.type = type
    }

}

final class ThemeSettingsViewController: SettingsTableViewController {

    private var settings = [TintSetting]()

    override func viewDidLoad() {
        super.viewDidLoad()
        SettingsManager.colors.forEach { color in
            var tintSetting = TintSetting(title: color.name,
                                          color: color,
                                          type: .checkmark)
            tintSetting.selectedHandler = { (setting, _) in
                guard let tintSetting: TintSetting = setting as? TintSetting else {
                    return
                }
                SettingsManager.shared.changeThemeColor(tintSetting.color.type)
            }
            settings.append(tintSetting)
        }
        self.reloadData([settings])

        let index = settings.firstIndex {
            return $0.color.type == SettingsManager.shared.themeColorType
        } ?? 0
        self.didSelectRow(at: IndexPath(row: index, section: 0), animated: false)
    }

}
