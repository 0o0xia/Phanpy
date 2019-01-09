//
//  SettingsTableViewController.swift
//  Phanpy
//
//  Created by 邵景添 on 2018/12/26.
//

import UIKit

class SettingsTableViewController: UIViewController {

    private var settings = [[SettingItem]]()
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
        register([ "SettingCell": UITableViewCell.self ])
    }

    final func reloadData(_ data: [[SettingItem]]) {
        settings.removeAll()
        data.forEach { self.settings.append($0) }
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    final func register(_ cellClasses: [String: UITableViewCell.Type]?) {
        cellClasses?.forEach {
            tableView.register($0.value, forCellReuseIdentifier: $0.key)
        }
    }

    final func didSelectRow(at indexPath: IndexPath, animated: Bool = true) {
        tableView.selectRow(at: indexPath, animated: animated, scrollPosition: .none)
    }
}

extension SettingsTableViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let setting = settings[indexPath.section][indexPath.row]
        setting.selectedHandler?(setting)
    }

}

extension SettingsTableViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let setting = settings[indexPath.section][indexPath.row]
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "SettingCell",
                                                                  for: indexPath)
        cell.imageView?.image = setting.icon
        cell.textLabel?.text = setting.title
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return settings.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings[section].count
    }

}
