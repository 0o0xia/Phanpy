//
//  Utilities.swift
//  Phanpy
//
//  Created by 李孛 on 2018/12/15.
//

protocol Configurable: AnyObject {}

extension Configurable {
    @discardableResult
    func configure(_ configuration: (Self) -> Void) -> Self {
        configuration(self)
        return self
    }
}

import Foundation.NSObject

extension NSObject: Configurable {}
