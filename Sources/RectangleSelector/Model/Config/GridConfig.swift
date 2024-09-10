//
//  GridConfig.swift
//  
//
//  Created by p-x9 on 2024/07/03
//  
//

import UIKit

public struct GridConfig {
    public var numberOfRows: Int
    public var numberOfColmuns: Int
    public var lineWidth: CGFloat
    public var lineColor: UIColor

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

extension GridConfig {
    public static let dummy: Self = .init(
        numberOfRows: 0,
        numberOfColmuns: 0,
        lineWidth: 0,
        lineColor: .clear
    )
}

extension GridConfig {
    var disabled: Self {
        var new = self
        new.lineColor = new.lineColor.disabled()
        return new
    }
}
