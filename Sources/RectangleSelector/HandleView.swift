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

    let shapeView: UIView = .init()
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
}

extension HandleView {
    private func setup() {
        isExclusiveTouch = true
        translatesAutoresizingMaskIntoConstraints = false
        shapeView.translatesAutoresizingMaskIntoConstraints = false
        shapeView.isUserInteractionEnabled = false
        shapeView.isExclusiveTouch = true

        addSubview(shapeView)
        heightConstraint = shapeView.heightAnchor.constraint(equalToConstant: 0)
        widthConstraint = shapeView.widthAnchor.constraint(equalToConstant: 0)

        NSLayoutConstraint.activate([
            heightConstraint,
            widthConstraint,
            shapeView.centerXAnchor.constraint(equalTo: centerXAnchor),
            shapeView.centerYAnchor.constraint(equalTo: centerYAnchor),
            heightAnchor.constraint(greaterThanOrEqualTo: shapeView.heightAnchor),
            widthAnchor.constraint(greaterThanOrEqualTo: shapeView.widthAnchor),
        ])
    }
}

extension HandleView {
    func apply(_ config: HandleConfig) {
        shapeView.backgroundColor = config.color
        shapeView.layer.borderWidth = config.lineWidth
        shapeView.layer.borderColor = config.lineColor.cgColor
        shapeView.layer.cornerRadius = config.cornerRadius

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
