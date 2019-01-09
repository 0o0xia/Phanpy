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

    func testInit0() {
        UserDefaults.standard.set("test",
                                  forKey: "SettingsManager.themeColorKey")
        UserDefaults.standard.synchronize()
        XCTAssertEqual(SettingsManager.shared.themeColorType, .default)
    }

    func testInit1() {
        UserDefaults.standard.set(nil,
                                  forKey: "SettingsManager.themeColorKey")
        UserDefaults.standard.synchronize()
        XCTAssertEqual(SettingsManager.shared.themeColorType, .default)
    }

    func testChangeColor() {
        SettingsManager.shared.changeThemeColor(.orange)
        let color = SettingsManager.shared.themeColor
        XCTAssertEqual(color.type, .orange)
    }

    func testChangeColor1() {
        SettingsManager.shared.changeThemeColor(.orange)
        SettingsManager.shared.changeThemeColor(.default)
        let defaultColor = SettingsManager.shared.themeColor
        XCTAssertEqual(defaultColor.type, .default)
    }

    func testRegister() {
        SettingsManager.shared.changeThemeColor(.green)
        SettingsManager.shared.register { (color) in
            XCTAssertEqual(color, Color.green.color)
        }
    }

}

// MARK: Models
extension SettingsTests {

    func testModels() {
        let icon = UIImage(color: .orange,
                           size: CGSize(width: 29, height: 29))
        let setting = Setting(title: "color",
                              type: .checkmark,
                              icon: icon)
        XCTAssertEqual(setting.title, "color")
        XCTAssertEqual(setting.type, .checkmark)
        XCTAssertEqual(setting.icon, icon)
    }
}
