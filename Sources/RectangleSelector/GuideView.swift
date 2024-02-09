//
//  GuideView.swift
//
//
//  Created by p-x9 on 2024/02/09.
//  
//

import UIKit

final class GuideView: UIView {

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
        backgroundColor = config.color.withAlphaComponent(CGFloat(config.opacity))
//        layer.opacity = config.opacity
        layer.borderWidth = config.lineWidth
        layer.borderColor = config.lineColor.cgColor
    }
}
