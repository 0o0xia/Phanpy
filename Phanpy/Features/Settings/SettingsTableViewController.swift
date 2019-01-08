//
//  SettingsTableViewController.swift
//  Phanpy
//
//  Created by 邵景添 on 2018/12/26.
//

import UIKit

enum SettingType: String {
    case `default` = "setting.type.default"
    case indicator = "setting.type.indicatort"
    case checkmark = "setting.type.checkmark"
}

protocol SettingCellable: AnyObject {
}

class SettingsTableViewController: UIViewController {

    private var settings = [[Settingable]]()
    private lazy var tableView = UITableView(frame: .zero, style: .grouped).then {
        $0.dataSource = self
        $0.delegate = self
    }

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = tableView
        register([
            .default: SettingCell.self,
            .indicator: IndicatorSettingCell.self,
            .checkmark: CheckSettingCell.self,
            ])
    }

    final func reloadData(_ data: [[Settingable]]) {
        settings.removeAll()
        data.forEach { self.settings.append($0) }
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    final func register(_ cellClasses: [SettingType: SettingCellable.Type]?) {
        cellClasses?.forEach {
            tableView.register($0.value, forCellReuseIdentifier: $0.key.rawValue)
        }
    }

    final func didSelectRow(at indexPath: IndexPath, animated: Bool = true) {
        tableView.selectRow(at: indexPath, animated: animated, scrollPosition: .none)
    }
}

extension SettingsTableViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell: SettingCellable = tableView.cellForRow(at: indexPath) as? SettingCellable else {
            return
        }

        let setting = settings[indexPath.section][indexPath.row]
        setting.selectedHandler?(setting, cell)
    }

}

extension SettingsTableViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let setting = settings[indexPath.section][indexPath.row]

        let cell: SettingCell = tableView.dequeueReusableCell(withIdentifier: setting.type.rawValue,
                                                              for: indexPath)
        cell.bind(setting)

        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return settings.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings[section].count
    }

}
