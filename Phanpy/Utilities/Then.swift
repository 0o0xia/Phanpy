//
//  Then.swift
//  Phanpy
//
//  Created by 李孛 on 2018/12/16.
//

protocol Then {}

extension Then where Self: AnyObject {
    func then(_ closure: (Self) -> Void) -> Self {
        closure(self)
        return self
    }
}

import Foundation.NSObject

extension NSObject: Then {}
