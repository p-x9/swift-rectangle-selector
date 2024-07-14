//
//  Config.swift
//
//
//  Created by p-x9 on 2024/02/09.
//  
//

import Foundation

public struct Config {
    public let handleConfig: HandleConfig

    public let guideConfig: GuideConfig
    public let gridConfig: GridConfig

    public init(
        handleConfig: HandleConfig,
        guideConfig: GuideConfig,
        gridConfig: GridConfig
    ) {
        self.handleConfig = handleConfig
        self.guideConfig = guideConfig
        self.gridConfig = gridConfig
    }
}

extension Config {
    public static var `default`: Config {
        .init(
            handleConfig: .default,
            guideConfig: .default,
            gridConfig: .default
        )
    }
}
