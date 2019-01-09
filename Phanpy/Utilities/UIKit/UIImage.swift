//
//  UIImage.swift
//  Phanpy
//
//  Created by 邵景添 on 2018/12/26.
//

import UIKit

extension UIImage {
    static func cornerImage(color: UIColor, size: CGSize = .zero, cornerRadius: CGFloat) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        let bounds = CGRect(origin: .zero, size: size)
        let image = renderer.image { (context) in
            color.setFill()
            let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
            path.addClip()
            context.cgContext.addPath(path.cgPath)
            context.fill(bounds)
        }
        return image
    }
}
