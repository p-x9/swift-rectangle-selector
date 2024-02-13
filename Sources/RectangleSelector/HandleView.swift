//
//  HandleView.swift
//
//
//  Created by p-x9 on 2024/02/08.
//  
//

import UIKit

protocol HandleViewDelegate: AnyObject {
    func handleView(_ view: HandleView, moved touch: UITouch)
}

final class HandleView: UIView {

    var gestureStartPoint: CGPoint = .zero

    weak var delegate: HandleViewDelegate?

    private var heightConstraint: NSLayoutConstraint!
    private var widthConstraint: NSLayoutConstraint!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HandleView {
    private func setup() {
        isExclusiveTouch = true
        translatesAutoresizingMaskIntoConstraints = false
        heightConstraint = heightAnchor.constraint(equalToConstant: 0)
        widthConstraint = widthAnchor.constraint(equalToConstant: 0)

        NSLayoutConstraint.activate([
            heightConstraint,
            widthConstraint
        ])
    }
}

extension HandleView {
    func apply(_ config: HandleConfig) {
        backgroundColor = config.color
        layer.borderWidth = config.lineWidth
        layer.borderColor = config.lineColor.cgColor
        layer.cornerRadius = config.cornerRadius

        heightConstraint.constant = config.size
        widthConstraint.constant = config.size
    }
}

extension HandleView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        gestureStartPoint = touch.location(in: self)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        delegate?.handleView(self, moved: touch)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        delegate?.handleView(self, moved: touch)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        delegate?.handleView(self, moved: touch)
    }
}
