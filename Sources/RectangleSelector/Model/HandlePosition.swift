//
//  HandlePosition.swift
//
//
//  Created by p-x9 on 2024/07/13
//  
//

import Foundation

enum HandlePosition {
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight

    case center

    case top
    case bottom
    case left
    case right
}

extension HandlePosition {
    var isVertex: Bool {
        switch self {
        case .topLeft, .topRight, .bottomLeft, .bottomRight:
            return true
        default:
            return false
        }
    }

    var isEdge: Bool {
        switch self {
        case .top, .bottom, .left, .right:
            return true
        default:
            return false
        }
    }
}
