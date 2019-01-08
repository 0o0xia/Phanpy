//
//  SettingsManager.swift
//  Phanpy
//
//  Created by 邵景添 on 2018/12/28.
//

import UIKit

enum ThemeColorType: String {
    case `default`
    case red
    case orange
    case yellow
    case green
    case tealBlue
    case blue
    case pink
}

final class SettingsManager {

    static let shared = SettingsManager()

    private(set) var themeColor: Color = .default
    private(set) var themeColorType: ThemeColorType = .default {
        didSet {
            themeColor = themeColor(withType: themeColorType)
        }
    }
    private var colorChangeHandlers = [(UIColor) -> Void]()
    init() {
        if let colorKey = UserDefaults.standard.string(forKey: SettingsManager.themeColorKey) {
            themeColorType = ThemeColorType(rawValue: colorKey) ?? .default
            themeColor = themeColor(withType: themeColorType)
        }
    }

    private func themeColor(withType: ThemeColorType) -> Color {
        let index = SettingsManager.colors.firstIndex { return $0.type == themeColorType } ?? 0
        return SettingsManager.colors[index]
    }
}

// MARK: Theme Color
extension SettingsManager {

    static private(set) var colors: [Color] = [
        .default,
        .red,
        .orange,
        .yellow,
        .green,
        .tealBlue,
        .blue,
        .pink,
        ]

    func changeThemeColor(_ colorType: ThemeColorType) {

        guard colorType != themeColorType else { return }

        themeColorType = colorType
        UserDefaults.standard.set(themeColorType.rawValue,
                                  forKey: SettingsManager.themeColorKey)

        executeThemeColorHandlers() // 运行 color 改变 blocks
    }

    func register(_ colorChangeHandler: @escaping (UIColor) -> Void) {
        colorChangeHandler(themeColor.color)
        colorChangeHandlers.append(colorChangeHandler)
    }

    private func executeThemeColorHandlers() {
        DispatchQueue.main.async {
            let color = self.themeColor.color
            self.colorChangeHandlers.forEach { $0(color) }
        }
    }
}

// MARK: Keys
extension SettingsManager {
    static let themeColorKey = "SettingsManager.themeColorKey"
}
