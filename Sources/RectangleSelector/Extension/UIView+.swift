//
//  UIView+.swift
//
//
//  Created by p-x9 on 2024/07/07
//  
//

import UIKit

extension UIView {
    func constraintEdges(equalTo view: UIView, insets: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
        [
            topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top),
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -insets.bottom),
            leftAnchor.constraint(equalTo: view.leftAnchor, constant: insets.left),
            rightAnchor.constraint(equalTo: view.rightAnchor, constant: -insets.right)
        ]
    }

    func constraintCenter(equalTo view: UIView, offset: CGPoint = .zero) -> [NSLayoutConstraint] {
        [
            centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: offset.x),
            centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: offset.y),
        ]
    }

    func constraintSize(equalTo view: UIView, offset: CGPoint = .zero) -> [NSLayoutConstraint] {
        [
            heightAnchor.constraint(equalTo: view.heightAnchor, constant: offset.x),
            widthAnchor.constraint(equalTo: view.widthAnchor, constant: offset.y),
        ]
    }
}
