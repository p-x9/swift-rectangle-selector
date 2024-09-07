//
//  HandleConfig.swift
//
//
//  Created by p-x9 on 2024/02/09.
//  
//

import UIKit

public struct HandleConfig {
    public var style: HandleStyle

    public var lineWidth: CGFloat
    public var lineColor: UIColor

    public var size: CGFloat

    public var color: UIColor

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

extension HandleConfig {
    public static let dummy: Self = .init(
        style: .edge,
        lineWidth: 0,
        lineColor: .clear,
        size: 0,
        color: .clear
    )
}

extension HandleConfig {
    var disabled: Self {
        var new = self
        new.lineColor = new.lineColor.disabled()
        new.color = new.color.disabled()
        return new
    }
}
