//
//  GuideView.swift
//
//
//  Created by p-x9 on 2024/02/09.
//  
//

import UIKit

protocol GuideViewDelegate: AnyObject {
    func guideView(_ view: GuideView, moved touch: UITouch)
}

final class GuideView: UIView {

    var gestureStartPoint: CGPoint = .zero

    weak var delegate: GuideViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GuideView {
    private func setup() {}
}

extension GuideView {
    func apply(_ config: GuideConfig) {
        backgroundColor = config.color
        layer.borderWidth = config.lineWidth
        layer.borderColor = config.lineColor.cgColor
    }
}

extension GuideView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        gestureStartPoint = touch.location(in: self)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        delegate?.guideView(self, moved: touch)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        delegate?.guideView(self, moved: touch)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        delegate?.guideView(self, moved: touch)
    }
}
