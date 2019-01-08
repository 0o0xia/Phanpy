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

        let color = SettingsManager.shared.themeColor.color
        let currentTintImage = UIImage(color: color,
                                       size: CGSize(width: 29, height: 29))
        var tintSetting = Setting(title: "Tint Color",
                                  type: .indicator,
                                  icon: currentTintImage)
        tintSetting.selectedHandler = { (_, _) in
            let controller = ThemeSettingsViewController()
            self.navigationController?.pushViewController(controller, animated: true)
        }

        self.reloadData([[tintSetting]])
    }
}

extension SettingsViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
