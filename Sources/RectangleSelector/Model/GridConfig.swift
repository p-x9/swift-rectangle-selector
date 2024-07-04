//
//  GridConfig.swift
//  
//
//  Created by p-x9 on 2024/07/03
//  
//

import UIKit

struct GridConfig {
    let numberOfRows: Int
    let numberOfColmuns: Int
    let lineWidth: CGFloat
    let lineColor: UIColor
}

extension GridConfig {
    static var `default`: Self {
        .init(
            numberOfRows: 3,
            numberOfColmuns: 3,
            lineWidth: 0.8,
            lineColor: .white
        )
    }
}
