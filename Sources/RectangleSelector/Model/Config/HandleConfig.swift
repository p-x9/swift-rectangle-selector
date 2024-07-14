//
//  HandleConfig.swift
//
//
//  Created by p-x9 on 2024/02/09.
//  
//

import UIKit

public struct HandleConfig {
    public let style: HandleStyle

    public let lineWidth: CGFloat
    public let lineColor: UIColor

    public let size: CGFloat

    public let color: UIColor

    public init(
        style: HandleStyle,
        lineWidth: CGFloat,
        lineColor: UIColor,
        size: CGFloat,
        color: UIColor
    ) {
        self.style = style
        self.lineWidth = lineWidth
        self.lineColor = lineColor
        self.size = size
        self.color = color
    }
}

extension HandleConfig {
    public static var `default`: HandleConfig {
        .init(
            style: .edge,
            lineWidth: 3,
            lineColor: .white,
            size: 30,
            color: .clear
        )
    }
}
