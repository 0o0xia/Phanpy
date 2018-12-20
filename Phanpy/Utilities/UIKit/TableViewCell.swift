//
//  TableViewCell.swift
//  Phanpy
//
//  Created by 李孛 on 2018/12/19.
//

import UIKit

class TableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        // https://pspdfkit.com/blog/2018/self-sizing-table-view-cells/#margins
        // http://openradar.appspot.com/46234942
        contentView.preservesSuperviewLayoutMargins = true
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
