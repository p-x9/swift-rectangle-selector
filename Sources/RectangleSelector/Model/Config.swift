//
//  Config.swift
//
//
//  Created by p-x9 on 2024/02/09.
//  
//

import Foundation

struct Config {
    let vertexHandleConfig: HandleConfig
    let edgeHandleConfig: HandleConfig

    let guideConfig: GuideConfig
}

extension Config {
    static var `default`: Config {
        .init(
            vertexHandleConfig: .vertexDefault,
            edgeHandleConfig: .edgeDefault,
            guideConfig: .default
        )
    }
}
