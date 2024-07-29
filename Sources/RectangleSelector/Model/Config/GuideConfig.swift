//
//  GuideConfig.swift
//
//
//  Created by p-x9 on 2024/02/09.
//  
//

import UIKit

public struct GuideConfig {
    public var lineWidth: CGFloat
    public var lineColor: UIColor

    public var color: UIColor

    public init(
        lineWidth: CGFloat,
        lineColor: UIColor,
        color: UIColor
    ) {
        self.lineWidth = lineWidth
        self.lineColor = lineColor
        self.color = color
    }
}

extension GuideConfig {
    public static var `default`: GuideConfig {
        .init(
            lineWidth: 3,
            lineColor: .white,
            color: .clear
        )
    }
}
