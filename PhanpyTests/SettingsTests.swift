//
//  SettingsTests.swift
//  PhanpyTests
//
//  Created by 邵景添 on 2019/1/9.
//

import XCTest
@testable import Phanpy

final class SettingsTests: XCTestCase {}

// MARK: SettingsManager
extension SettingsTests {
    func testThemeColor() {
        UserDefaults.standard.set("Default", forKey: "AppSettings.themeColorKey")
        let color = AppSettings.shared.themeColor
        XCTAssertEqual(color, UIColor(red: 88/255, green: 86/255, blue: 214/255, alpha: 1))

        AppSettings.shared.changeThemeColor(to: "Orange")
        XCTAssertEqual(AppSettings.shared.themeColor, UIColor(red: 255/255, green: 149/255, blue: 0/255, alpha: 1))
    }
}

// MARK: Models
extension SettingsTests {
    func testModels() {
        let icon = UIImage.cornerImage(color: .orange, size: CGSize(width: 29, height: 29), cornerRadius: 7)
        let setting = Setting(title: "color",
                              icon: icon)
        XCTAssertEqual(setting.title, "color")
        XCTAssertEqual(setting.icon, icon)
    }
}
