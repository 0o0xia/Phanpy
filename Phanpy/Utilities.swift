//
//  Utilities.swift
//  Phanpy
//
//  Created by 李孛 on 2018/12/15.
//

import UIKit

extension UIImageView {
    convenience init(configuration: (UIImageView) -> Void) {
        self.init()
        configuration(self)
    }
}

extension UILabel {
    convenience init(configuration: (UILabel) -> Void) {
        self.init()
        configuration(self)
    }
}
