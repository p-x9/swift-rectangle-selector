//
//  HandleConfig.swift
//
//
//  Created by p-x9 on 2024/02/09.
//  
//

import UIKit

struct HandleConfig {
    let style: HandleStyle

    let lineWidth: CGFloat
    let lineColor: UIColor

    let size: CGFloat

    let color: UIColor
}

extension HandleConfig {
    static var `default`: HandleConfig {
        .init(
            style: .edge,
            lineWidth: 3,
            lineColor: .white,
            size: 30,
            color: .clear
        )
    }
}
