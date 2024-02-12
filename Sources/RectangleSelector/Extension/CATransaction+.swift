//
//  CATransaction+.swift
//
//
//  Created by p-x9 on 2024/02/12.
//  
//

import QuartzCore

extension CATransaction {
    static func withoutAnimation(_ closure: () -> Void) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        closure()
        CATransaction.commit()
    }
}
