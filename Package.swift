// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "RectangleSelector",
    products: [
        .library(
            name: "RectangleSelector",
            targets: ["RectangleSelector"]
        ),
    ],
    targets: [
        .target(
            name: "RectangleSelector"
        ),
        .testTarget(
            name: "RectangleSelectorTests",
            dependencies: ["RectangleSelector"]
        ),
    ]
)
