//
//  SettingsViewController.swift
//  Phanpy
//
//  Created by 邵景添 on 2018/12/26.
//

import UIKit

final class SettingsViewController: SettingsTableViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let color = AppSettings.shared.themeColor
        let currentTintImage = UIImage.cornerImage(color: color,
                                                   size: CGSize(width: 29, height: 29),
                                                   cornerRadius: 7)
        var tintSetting = Setting(title: "Tint Color",
                                  icon: currentTintImage)
        tintSetting.selectedHandler = { [weak self] _ in
            let controller = ThemeSettingsViewController()
            self?.navigationController?.pushViewController(controller, animated: true)
        }
        self.reloadData([[tintSetting]])
    }
}

// MARK: UITableView DataSource, Delegate
extension SettingsViewController {

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
