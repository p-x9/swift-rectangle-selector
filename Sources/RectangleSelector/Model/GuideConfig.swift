//
//  GuideConfig.swift
//
//
//  Created by p-x9 on 2024/02/09.
//  
//

import UIKit

struct GuideConfig {
    let lineWidth: CGFloat
    let lineColor: UIColor

    let color: UIColor
}

extension GuideConfig {
    static var `default`: GuideConfig {
        .init(
            lineWidth: 1,
            lineColor: .white,
            color: .clear
        )
    }
}
