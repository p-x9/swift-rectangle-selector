//
//  HandleConfig.swift
//
//
//  Created by p-x9 on 2024/02/09.
//  
//

import UIKit

struct HandleConfig {
    let lineWidth: CGFloat
    let lineColor: UIColor

    let cornerRadius: CGFloat

    let size: CGFloat

    let color: UIColor
}

extension HandleConfig {
    static var vertexDefault: HandleConfig {
        .init(
            lineWidth: 1.5,
            lineColor: .white,
            cornerRadius: 10,
            size: 20,
            color: .clear
        )
    }

    static var edgeDefault: HandleConfig {
        .init(
            lineWidth: 1.5,
            lineColor: .white,
            cornerRadius: 0,
            size: 20,
            color: .clear
        )
    }
}
