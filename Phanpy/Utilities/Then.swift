//
//  Then.swift
//  Phanpy
//
//  Created by 李孛 on 2018/12/16.
//

protocol Then: AnyObject {}

extension Then {
    func then(_ closure: (Self) throws -> Void) rethrows -> Self {
        try closure(self)
        return self
    }
}

import Foundation.NSObject

extension NSObject: Then {}
