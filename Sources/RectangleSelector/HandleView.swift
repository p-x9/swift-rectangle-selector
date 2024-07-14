//
//  HandleView.swift
//
//
//  Created by p-x9 on 2024/02/08.
//  
//

import UIKit

protocol HandleViewDelegate: AnyObject {
    func handleView(_ view: HandleView, start touch: UITouch)
    func handleView(_ view: HandleView, moved touch: UITouch)
    func handleView(_ view: HandleView, end touch: UITouch)
}

final class HandleView: UIView {

    private(set) var position: HandlePosition = .center

    let visualView: UIView = .init()

    let normalShapeLayer: CAShapeLayer = .init()
    let edgeShapeLayer: EdgeHandleShapeLayer = .init()

    var gestureStartPoint: CGPoint = .zero

    weak var delegate: HandleViewDelegate?

    private var heightConstraint: NSLayoutConstraint!
    private var widthConstraint: NSLayoutConstraint!

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
            normalShapeLayer.frame = visualView.bounds
            edgeShapeLayer.frame = visualView.bounds
        }
    }
}

extension HandleView {
    private func setup() {
        isExclusiveTouch = true
        translatesAutoresizingMaskIntoConstraints = false
        visualView.translatesAutoresizingMaskIntoConstraints = false
        visualView.isUserInteractionEnabled = false
        visualView.isExclusiveTouch = true
        visualView.layer.addSublayer(normalShapeLayer)
        visualView.layer.addSublayer(edgeShapeLayer)

        addSubview(visualView)
        heightConstraint = visualView.heightAnchor.constraint(equalToConstant: 0)
        widthConstraint = visualView.widthAnchor.constraint(equalToConstant: 0)

        NSLayoutConstraint.activate([
            heightConstraint,
            widthConstraint,
            heightAnchor.constraint(greaterThanOrEqualTo: visualView.heightAnchor),
            widthAnchor.constraint(greaterThanOrEqualTo: visualView.widthAnchor),
        ])

        NSLayoutConstraint.activate(
            visualView.constraintCenter(equalTo: self)
        )
    }
}

extension HandleView {
    func apply(_ config: HandleConfig) {
        switch config.style {
        case .edge:
            normalShapeLayer.isHidden = true
            edgeShapeLayer.isHidden = false
            edgeShapeLayer.apply(lineWidth: config.lineWidth)
            edgeShapeLayer.apply(fillColor: config.lineColor.cgColor)

        case .circleAndSquare:
            normalShapeLayer.isHidden = false
            edgeShapeLayer.isHidden = true
            normalShapeLayer.backgroundColor = config.color.cgColor
            normalShapeLayer.borderWidth = config.lineWidth
            normalShapeLayer.borderColor = config.lineColor.cgColor

            if position.isVertex {
                normalShapeLayer.cornerRadius = config.size / 2
            } else {
                normalShapeLayer.cornerRadius = 0
            }
        }

        heightConstraint.constant = config.size
        widthConstraint.constant = config.size
    }

    func set(_ position: HandlePosition) {
        self.position = position
        edgeShapeLayer.apply(position: position)
        if position.isVertex {
            normalShapeLayer.cornerRadius = heightConstraint.constant / 2
        } else {
            normalShapeLayer.cornerRadius = 0
        }
    }
}

extension HandleView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        gestureStartPoint = touch.location(in: self)
        delegate?.handleView(self, start: touch)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        delegate?.handleView(self, moved: touch)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        delegate?.handleView(self, end: touch)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        delegate?.handleView(self, end: touch)
    }
}
