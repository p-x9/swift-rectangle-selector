//
//  GridView.swift
//
//
//  Created by p-x9 on 2024/07/02
//  
//

import UIKit

class GridView: UIView {
    public private(set) var config: GridConfig = .default

    private let horizontalLineLayer = CALayer()
    private let verticalLineLayer = CALayer()

    private let horizontalReplicator = CAReplicatorLayer()
    private let verticalReplicator = CAReplicatorLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        horizontalReplicator.frame = bounds
        verticalReplicator.frame = bounds

        updateLineLayer()
        updateReplicator()
    }
}

extension GridView {
    func apply(_ config: GridConfig) {
        self.config = config

        horizontalReplicator.instanceCount = config.numberOfColmuns - 1
        verticalReplicator.instanceCount = config.numberOfRows - 1
        horizontalReplicator.instanceColor = UIColor.white.cgColor
        verticalReplicator.instanceColor = UIColor.white.cgColor

        updateReplicator()

        horizontalLineLayer.borderWidth = config.lineWidth
        horizontalLineLayer.borderColor = config.lineColor.cgColor
        verticalLineLayer.borderWidth = config.lineWidth
        verticalLineLayer.borderColor = config.lineColor.cgColor
    }
}

extension GridView {
    private func setup() {
        layer.addSublayer(horizontalReplicator)
        layer.addSublayer(verticalReplicator)

        horizontalReplicator.addSublayer(horizontalLineLayer)
        verticalReplicator.addSublayer(verticalLineLayer)

        apply(config)
        updateLineLayer()
    }

    private func updateLineLayer() {
        let size = frame.size
        let horizontalOffset = size.width / CGFloat(config.numberOfColmuns)
        let verticalOffset = size.height / CGFloat(config.numberOfRows)

        horizontalLineLayer.frame = .init(
            origin: .init(
                x: horizontalOffset,
                y: 0
            ),
            size: .init(width: config.lineWidth, height: frame.height)
        )
        verticalLineLayer.frame = .init(
            origin: .init(
                x: 0,
                y: verticalOffset
            ),
            size: .init(width: frame.width, height: config.lineWidth)
        )
    }

    private func updateReplicator() {
        let size = frame.size
        let horizontalOffset = size.width / CGFloat(config.numberOfColmuns)
        let verticalOffset = size.height / CGFloat(config.numberOfRows)

        horizontalReplicator.instanceTransform = CATransform3DMakeTranslation(
            horizontalOffset, 0, 0
        )
        verticalReplicator.instanceTransform = CATransform3DMakeTranslation(
            0, verticalOffset, 0
        )
    }
}
//
//@available(iOS 17.0, *)
//#Preview {
//    let grid = GridView()
//    grid.backgroundColor = .black
//    grid.layer.borderWidth = 1
//    grid.layer.borderColor = UIColor.orange.cgColor
//    return grid
//}
