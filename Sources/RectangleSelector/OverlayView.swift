//
//  OverlayView.swift
//
//
//  Created by p-x9 on 2024/07/07
//  
//

import UIKit

final class OverlayView: UIView {

    private(set) var maskedFrame: CGRect = .zero

    private let overlayLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.black.withAlphaComponent(0.5).cgColor
        return layer
    }()

    private let overlayMaskLayer: CAShapeLayer  = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.black.cgColor
        layer.fillRule = .evenOdd
        return layer
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)

        CATransaction.withoutAnimation {
            overlayLayer.frame = self.bounds
            overlayLayer.path = .init(rect: self.bounds, transform: nil)

            updateMaskedFrame()
        }
    }
}

extension OverlayView {
    private func setup() {
        isUserInteractionEnabled = false
        layer.addSublayer(overlayLayer)
        overlayLayer.mask = overlayMaskLayer
        updateMaskedFrame()
    }

    private func updateMaskedFrame() {
        overlayMaskLayer.frame = self.bounds
        let path = UIBezierPath(rect: maskedFrame)
        path.append(.init(rect: self.bounds))
        overlayMaskLayer.path = path.cgPath
    }
}

extension OverlayView {
    func apply(masked maskedFrame: CGRect) {
        self.maskedFrame = maskedFrame
        CATransaction.withoutAnimation {
            updateMaskedFrame()
        }
    }
}
