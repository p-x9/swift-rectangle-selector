//
//  GridConfig.swift
//  
//
//  Created by p-x9 on 2024/07/03
//  
//

import UIKit

public struct GridConfig {
    public let numberOfRows: Int
    public let numberOfColmuns: Int
    public let lineWidth: CGFloat
    public let lineColor: UIColor

    public init(
        numberOfRows: Int,
        numberOfColmuns: Int,
        lineWidth: CGFloat,
        lineColor: UIColor
    ) {
        self.numberOfRows = numberOfRows
        self.numberOfColmuns = numberOfColmuns
        self.lineWidth = lineWidth
        self.lineColor = lineColor
    }
}

extension GridConfig {
    public static var `default`: Self {
        .init(
            numberOfRows: 3,
            numberOfColmuns: 3,
            lineWidth: 1,
            lineColor: .white
        )
    }
}
