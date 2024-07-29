//
//  Config.swift
//
//
//  Created by p-x9 on 2024/02/09.
//  
//

import Foundation

public struct Config {
    public var handleConfigs: HandleConfigs

    public var guideConfig: GuideConfig
    public var gridConfig: GridConfig

    public init(
        handleConfigs: HandleConfigs,
        guideConfig: GuideConfig,
        gridConfig: GridConfig
    ) {
        self.handleConfigs = handleConfigs
        self.guideConfig = guideConfig
        self.gridConfig = gridConfig
    }
}

extension Config {
    public static var `default`: Config {
        .init(
            handleConfigs: .init(all: .default),
            guideConfig: .default,
            gridConfig: .default
        )
    }
}
