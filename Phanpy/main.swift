//
//  main.swift
//  Phanpy
//
//  Created by 李孛 on 2018/12/12.
//

import UIKit

let delegateClassName = (NSClassFromString("XCTest") == nil) ? NSStringFromClass(AppDelegate.self) : nil

UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, delegateClassName)
