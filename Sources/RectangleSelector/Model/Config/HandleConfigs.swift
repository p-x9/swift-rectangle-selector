//
//  HandleConfigs.swift
//
//
//  Created by p-x9 on 2024/07/24
//  
//

import Foundation

public struct HandleConfigs {
    public let vertex: HandleConfig
    public let edge: HandleConfig
    public let center: HandleConfig

    public init(
        vertex: HandleConfig,
        edge: HandleConfig,
        center: HandleConfig
    ) {
        self.vertex = vertex
        self.edge = edge
        self.center = center
    }

    public init(all config: HandleConfig) {
        self.init(
            vertex: config,
            edge: config,
            center: config
        )
    }
}
