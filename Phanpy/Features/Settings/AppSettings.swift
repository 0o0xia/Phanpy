//
//  AppSettings.swift
//  Phanpy
//
//  Created by 邵景添 on 2018/12/28.
//

import UIKit

final class AppSettings {

    static let shared = AppSettings()

    private(set) var themeColor: UIColor

    private init() {
        let colorKey = UserDefaults.standard.string(forKey: AppSettings.themeColorKey)
        themeColor = AppSettings.themeColor(withColorName: colorKey)
    }

}

// MARK: Theme Color
extension AppSettings {
    private static let themeColorKey = "AppSettings.themeColorKey"

    func changeThemeColor(to colorName: String) {
        UserDefaults.standard.set(colorName, forKey: AppSettings.themeColorKey)
        themeColor = AppSettings.themeColor(withColorName: colorName)
    }

    static private(set) var colorMaps: [String: UIColor] = [
        "Default": UIColor(red: 88/255, green: 86/255, blue: 214/255, alpha: 1),
        "Red": UIColor(red: 255/255, green: 59/255, blue: 48/255, alpha: 1),
        "Orange": UIColor(red: 255/255, green: 149/255, blue: 0/255, alpha: 1),
        "Yellow": UIColor(red: 255/255, green: 204/255, blue: 0/255, alpha: 1),
        "Green": UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1),
        "Teal Blue": UIColor(red: 90/255, green: 200/255, blue: 250/255, alpha: 1),
        "Blue": UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1),
        "Pink": UIColor(red: 255/255, green: 45/255, blue: 85/255, alpha: 1),
    ]

    private static func themeColor(withColorName key: String?) -> UIColor {
        guard let key = key, let color = AppSettings.colorMaps[key] else {
            return UIColor(red: 88/255, green: 86/255, blue: 214/255, alpha: 1)
        }
        return color
    }
}
