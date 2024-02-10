//
//  HandleView.swift
//
//
//  Created by p-x9 on 2024/02/08.
//  
//

import UIKit

protocol HandleViewDelegate: AnyObject {
    func handleView(_ view: HandleView, updatePanState recognizer: UIPanGestureRecognizer)
}

final class HandleView: UIView {

    var isEnabled: Bool = true
    var gestureStartPoint: CGPoint = .zero

    weak var delegate: HandleViewDelegate?

    private let panGestureRecognizer = UIPanGestureRecognizer()

    private var heightConstraint: NSLayoutConstraint!
    private var widthConstraint: NSLayoutConstraint!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state == .began {
            gestureStartPoint = gestureRecognizer.location(in: self)
        }
        delegate?.handleView(self, updatePanState: gestureRecognizer)
    }
}

extension HandleView {
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        heightConstraint = heightAnchor.constraint(equalToConstant: 0)
        widthConstraint = widthAnchor.constraint(equalToConstant: 0)

        NSLayoutConstraint.activate([
            heightConstraint,
            widthConstraint
        ])

        panGestureRecognizer.addTarget(self, action: #selector(handlePanGesture(_:)))
        addGestureRecognizer(panGestureRecognizer)
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
