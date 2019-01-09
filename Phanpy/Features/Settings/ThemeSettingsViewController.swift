//
//  ThemeSettingsViewController.swift
//  Phanpy
//
//  Created by 邵景添 on 2018/12/26.
//

import UIKit

private struct TintSetting: SettingItem {
    var title: String
    var icon: UIImage?
    var color: UIColor
    var selectedHandler: ((SettingItem) -> Void)?

    init(title: String, color: UIColor) {
        self.title = title
        self.icon = UIImage.cornerImage(color: color,
                                        size: CGSize(width: 29, height: 29),
                                        cornerRadius: 7)
        self.color = color
    }

}

final class ThemeSettingsViewController: SettingsTableViewController {

    private var settings = [TintSetting]()

    override func viewDidLoad() {
        super.viewDidLoad()

        AppSettings.colorMaps.forEach {
            var tintSetting = TintSetting(title: $0.key,
                                          color: $0.value)
            tintSetting.selectedHandler = { setting in
                guard let tintSetting: TintSetting = setting as? TintSetting else {
                    return
                }
                UIApplication.shared.keyWindow?.tintColor = tintSetting.color
                AppSettings.shared.changeThemeColor(to: tintSetting.title)
            }
            settings.append(tintSetting)
        }
        self.reloadData([settings])

        let index = settings.firstIndex {
            return $0.color == AppSettings.shared.themeColor
        } ?? 0
        self.didSelectRow(at: IndexPath(row: index, section: 0), animated: false)
    }

}

// MARK: UITableView DataSource, Delegate
extension ThemeSettingsViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.selectionStyle = .none
        cell.accessoryType = (tableView.indexPathForSelectedRow == indexPath) ? .checkmark : .none
        return cell
    }

    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
        return indexPath
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
    }
}
