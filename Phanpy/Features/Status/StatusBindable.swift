//
//  StatusBindable.swift
//  Phanpy
//
//  Created by 李孛 on 2018/12/19.
//

import MastodonKit

protocol StatusBindable {
    func bind(_ status: Status)
}

typealias StatusBindableTableViewCell = UITableViewCell & StatusBindable
