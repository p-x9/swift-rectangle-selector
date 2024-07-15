//
//  EdgeHandleShapeLayer.swift
//
//
//  Created by p-x9 on 2024/07/06
//  
//

import UIKit

class EdgeHandleShapeLayer: CALayer {
    private(set) var handlePosition: HandlePosition = .topLeft
    private(set) var lineWidth: CGFloat = 1

    private let shapeLayer: CAShapeLayer = .init()

    override init() {
        super.init()
        setup()
    }

    override init(layer: Any) {
        super.init(layer: layer)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSublayers() {
        super.layoutSublayers()

        CATransaction.withoutAnimation {
            shapeLayer.frame = bounds
            updatePath()
        }
    }
}

extension EdgeHandleShapeLayer {
    func apply(position: HandlePosition) {
        self.handlePosition = position
        shapeLayer.transform = CATransform3DMakeRotation(position.angle, 0, 0, 1)
    }
    
    func apply(lineWidth: CGFloat) {
        self.lineWidth = lineWidth
        updatePath()
    }

    func apply(fillColor: CGColor) {
        shapeLayer.fillColor = fillColor
    }
}

extension EdgeHandleShapeLayer {
    private func setup() {
        addSublayer(shapeLayer)
        apply(position: handlePosition)
    }

    private func updatePath() {
        if handlePosition == .center {
            shapeLayer.path = makePathForCenter()
        } else if handlePosition.isVertex {
            shapeLayer.path = makePathForCorner()
        } else {
            shapeLayer.path = makePathForEdge()
        }
    }
}

extension EdgeHandleShapeLayer {
    private func makePathForCorner() -> CGPath {
        let path = CGMutablePath()
        path.move(to: .init(x: bounds.midX, y: bounds.midY))
        path.addLine(to: .init(x: bounds.maxX, y: bounds.midY)) // →
        path.addLine(to: .init(x: bounds.maxX, y: bounds.midY - lineWidth)) // ↑
        path.addLine(to: .init(x: bounds.midX - lineWidth, y: bounds.midY - lineWidth)) // ←
        path.addLine(to: .init(x: bounds.midX - lineWidth, y: bounds.maxY)) // ↓
        path.addLine(to: .init(x: bounds.midX, y: bounds.maxY)) // →
        path.addLine(to: .init(x: bounds.midX, y: bounds.midY)) // ↑
        path.closeSubpath()

        return path
    }

    private func makePathForEdge() -> CGPath {
        let path = CGMutablePath()
        path.move(to: .init(x: bounds.midX, y: 0))
        path.addLine(to: .init(x: bounds.midX - lineWidth, y: 0)) // ←
        path.addLine(to: .init(x: bounds.midX - lineWidth, y: bounds.maxY)) // ↓
        path.addLine(to: .init(x: bounds.midX, y: bounds.maxY)) // →
        path.addLine(to: .init(x: bounds.midX, y: 0)) // ↑
        path.closeSubpath()

        return path
    }

    private func makePathForCenter() -> CGPath {
        let path = CGMutablePath()
//        path.move(to: .init(x: bounds.midX - lineWidth / 2, y: bounds.midY / 2))
//        path.addLine(to: .init(x: bounds.midX + lineWidth / 2, y: bounds.midY / 2)) // →
//        path.addLine(to: .init(x: bounds.midX + lineWidth / 2, y: bounds.midY - lineWidth / 2)) // ↓
//        path.addLine(to: .init(x: bounds.midX * 1.5, y: bounds.midY - lineWidth / 2)) // →
//        path.addLine(to: .init(x: bounds.midX * 1.5, y: bounds.midY + lineWidth / 2)) // ↓
//        path.addLine(to: .init(x: bounds.midX + lineWidth / 2, y: bounds.midY + lineWidth / 2)) // ←
//        path.addLine(to: .init(x: bounds.midX + lineWidth / 2, y: bounds.midY * 1.5)) // ↓
//        path.addLine(to: .init(x: bounds.midX - lineWidth / 2, y: bounds.midY * 1.5)) // ←
//        path.addLine(to: .init(x: bounds.midX - lineWidth / 2, y: bounds.midY + lineWidth / 2)) // ↑
//        path.addLine(to: .init(x: bounds.midX / 2, y: bounds.midY + lineWidth / 2)) // ←
//        path.addLine(to: .init(x: bounds.midX / 2, y: bounds.midY - lineWidth / 2)) // ↑
//        path.addLine(to: .init(x: bounds.midX - lineWidth / 2, y: bounds.midY - lineWidth / 2)) // →
//        path.addLine(to: .init(x: bounds.midX - lineWidth / 2, y: bounds.midY)) // ↑
//        path.closeSubpath()

        path.move(to: .init(x: bounds.midX - lineWidth / 2, y: 0))
        path.addLine(to: .init(x: bounds.midX + lineWidth / 2, y: 0)) // →
        path.addLine(to: .init(x: bounds.midX + lineWidth / 2, y: bounds.midY - lineWidth / 2)) // ↓
        path.addLine(to: .init(x: bounds.maxX, y: bounds.midY - lineWidth / 2)) // →
        path.addLine(to: .init(x: bounds.maxX, y: bounds.midY + lineWidth / 2)) // ↓
        path.addLine(to: .init(x: bounds.midX + lineWidth / 2, y: bounds.midY + lineWidth / 2)) // ←
        path.addLine(to: .init(x: bounds.midX + lineWidth / 2, y: bounds.maxY)) // ↓
        path.addLine(to: .init(x: bounds.midX - lineWidth / 2, y: bounds.maxY)) // ←
        path.addLine(to: .init(x: bounds.midX - lineWidth / 2, y: bounds.midY + lineWidth / 2)) // ↑
        path.addLine(to: .init(x: 0, y: bounds.midY + lineWidth / 2)) // ←
        path.addLine(to: .init(x: 0, y: bounds.midY - lineWidth / 2)) // ↑
        path.addLine(to: .init(x: bounds.midX - lineWidth / 2, y: bounds.midY - lineWidth / 2)) // →
        path.addLine(to: .init(x: bounds.midX - lineWidth / 2, y: bounds.midY)) // ↑
        path.closeSubpath()

        return path
    }
}

fileprivate extension HandlePosition {
    var angle: CGFloat {
        switch self {
        case .topLeft: 0
        case .topRight: .pi / 2
        case .bottomLeft: -.pi / 2
        case .bottomRight: .pi
        case .left: 0
        case .top: .pi / 2
        case .bottom: -.pi / 2
        case .right: .pi
        case .center: 0
        }
    }
}

//@available(iOS 17.0, *)
//#Preview {
//    let size = CGSize(width: 200, height: 200)
//
//    let v = UIView()
//    let layer = EdgeHandleShapeLayer()
//    layer.frame = .init(
//        origin: .init(x: 100, y: 100),
//        size: size
//    )
//    layer.borderWidth = 1
//    layer.apply(fillColor: UIColor.red.cgColor)
//    layer.apply(lineWidth: 10)
//    layer.apply(position: .center)
//
//    // center
//    let sub = CALayer()
//    sub.borderWidth = 1
//    sub.frame = .init(
//        origin: .zero,
//        size: .init(width: size.width / 2, height: size.height / 2)
//    )
//    layer.addSublayer(sub)
//
//    v.layer.addSublayer(layer)
//    return v
//}
