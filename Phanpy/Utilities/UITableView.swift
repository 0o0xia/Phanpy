//
//  UITableView.swift
//  Phanpy
//
//  Created by 李孛 on 2018/12/18.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(
        withIdentifier identifier: String,
        for indexPath: IndexPath
    ) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
            fatalError()
        }
        return cell
    }
}
