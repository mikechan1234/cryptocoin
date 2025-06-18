// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CryptoCoinCore",
    platforms: [
        .iOS(.v15),
        .macOS(.v10_15),
        .tvOS(.v15),
        .watchOS(.v8)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "CryptoCoinCore",
            targets: ["CryptoCoinCore"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "CryptoCoinCore"),
        .testTarget(
            name: "CryptoCoinCoreTests",
            dependencies: ["CryptoCoinCore"],
            resources: [
                .process("Resources/coins.json"),
                .process("Resources/coins_response_valid.json")
            ]
        ),
    ]
)
