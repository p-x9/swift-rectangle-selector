//
//  UIColor+.swift
//
//
//  Created by p-x9 on 2024/09/07
//  
//

import UIKit

extension UIColor {
    func disabled() -> UIColor {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0

        if self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return UIColor(
                hue: hue,
                saturation: saturation,
                brightness: brightness,
                alpha: max(alpha * 0.8, 0)
            )
        }

        return self
    }
}
