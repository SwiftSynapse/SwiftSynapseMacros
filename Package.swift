// swift-tools-version: 6.4

import CompilerPluginSupport
import PackageDescription

let package = Package(
    name: "SwiftSynapseMacros",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .visionOS(.v26),
    ],
    products: [
        .library(
            name: "SwiftSynapseMacrosClient",
            targets: ["SwiftSynapseMacrosClient"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "602.0.0"),
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
    ],
    targets: [
        .macro(
            name: "SwiftSynapseMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            ],
            exclude: ["Examples"]
        ),
        .target(
            name: "SwiftSynapseMacrosClient",
            dependencies: [
                "SwiftSynapseMacros",
            ]
        ),
        .testTarget(
            name: "SwiftSynapseMacrosTests",
            dependencies: [
                "SwiftSynapseMacros",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
    ]
)
