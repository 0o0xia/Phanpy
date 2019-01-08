//
//  Color.swift
//  Phanpy
//
//  Created by 邵景添 on 2019/1/8.
//

import UIKit

struct Color {
    let name: String
    let color: UIColor
    let type: ThemeColorType

    init(name: String, color: UIColor, type: ThemeColorType) {
        self.name = name
        self.color = color
        self.type = type
    }

    static var `default` = Color(
        name: "Default",
        color: UIColor(red: 88/255, green: 86/255, blue: 214/255, alpha: 1),
        type: .default
    )
    static var red = Color(
        name: "Red",
        color: UIColor(red: 255/255, green: 59/255, blue: 48/255, alpha: 1),
        type: .red
    )
    static var orange = Color(
        name: "Orange",
        color: UIColor(red: 255/255, green: 149/255, blue: 0/255, alpha: 1),
        type: .orange
    )
    static var yellow = Color(
        name: "Yellow",
        color: UIColor(red: 255/255, green: 204/255, blue: 0/255, alpha: 1),
        type: .yellow
    )
    static var green = Color(
        name: "Green",
        color: UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1),
        type: .green
    )
    static var tealBlue = Color(
        name: "Teal Blue",
        color: UIColor(red: 90/255, green: 200/255, blue: 250/255, alpha: 1),
        type: .tealBlue
    )
    static var blue = Color(
        name: "Blue",
        color: UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1),
        type: .blue
    )
    static var pink = Color(
        name: "Pink",
        color: UIColor(red: 255/255, green: 45/255, blue: 85/255, alpha: 1),
        type: .pink
    )
}
