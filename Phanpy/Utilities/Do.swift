//
//  Do.swift
//  Phanpy
//
//  Created by 李孛 on 2018/12/17.
//

protocol Do {}

extension Do {
    func `do`(_ closure: (Self) throws -> Void) rethrows {
        try closure(self)
    }
}

import Foundation.NSObject

extension NSObject: Do {}
