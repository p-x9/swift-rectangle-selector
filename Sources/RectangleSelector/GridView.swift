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

        CATransaction.withoutAnimation {
            horizontalReplicator.frame = bounds
            verticalReplicator.frame = bounds

            updateLineLayer()
            updateReplicator()
        }
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

        horizontalLineLayer.backgroundColor = config.lineColor.cgColor
        verticalLineLayer.backgroundColor = config.lineColor.cgColor
    }
}

extension GridView {
    private func setup() {
        layer.addSublayer(horizontalReplicator)
        layer.addSublayer(verticalReplicator)

        horizontalReplicator.addSublayer(horizontalLineLayer)
        verticalReplicator.addSublayer(verticalLineLayer)

        // To aoid line layer flickering when lineWidth is less than 1.
        if traitCollection.displayScale != 0 {
            horizontalLineLayer.rasterizationScale = traitCollection.displayScale
            verticalLineLayer.rasterizationScale = traitCollection.displayScale
            horizontalLineLayer.shouldRasterize = true
            verticalLineLayer.shouldRasterize = true
        }

        apply(config)
        updateLineLayer()
    }

    private func updateLineLayer() {
        let size = bounds.size
        let horizontalOffset = size.width / CGFloat(config.numberOfColmuns)
        let verticalOffset = size.height / CGFloat(config.numberOfRows)

        horizontalLineLayer.frame = .init(
            origin: .init(
                x: horizontalOffset,
                y: 0
            ),
            size: .init(width: config.lineWidth, height: size.height)
        )
        verticalLineLayer.frame = .init(
            origin: .init(
                x: 0,
                y: verticalOffset
            ),
            size: .init(width: size.width, height: config.lineWidth)
        )
    }

    private func updateReplicator() {
        let size = bounds.size
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
