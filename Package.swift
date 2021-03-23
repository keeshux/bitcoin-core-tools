// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "bitcoin-core-tools",
    platforms: [
        .macOS(.v11), .iOS(.v14)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "JSONRPC",
            targets: ["JSONRPC"]
        ),
        .library(
            name: "BitcoinAPI",
            targets: ["BitcoinAPI"]
        ),
        .library(
            name: "BitcoinTools",
            targets: ["BitcoinTools"]
        ),
        .library(
            name: "BitcoinWallet",
            targets: ["BitcoinWallet"]
        ),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.4.0"),
        .package(url: "https://github.com/keeshux/libbase58.git", .branch("master")),
        .package(url: "https://github.com/0xDEADP00L/Bech32.git", from: "1.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "JSONRPC",
            dependencies: [
                .product(name: "Logging", package: "swift-log"),
            ]
        ),
        .testTarget(
            name: "JSONRPCTests",
            dependencies: ["JSONRPC"]
        ),
        .target(
            name: "BitcoinAPI",
            dependencies: ["JSONRPC"]
        ),
        .testTarget(
            name: "BitcoinAPITests",
            dependencies: ["BitcoinAPI"]
        ),
        .target(
            name: "BitcoinTools",
            dependencies: [
                "libbase58",
                "Bech32"
            ]
        ),
        .testTarget(
            name: "BitcoinToolsTests",
            dependencies: ["BitcoinTools"]
        ),
        .target(
            name: "BitcoinWallet",
            dependencies: [
                "BitcoinAPI",
                "BitcoinTools",
            ]
        ),
        .testTarget(
            name: "BitcoinWalletTests",
            dependencies: ["BitcoinWallet"],
            resources: [
                .process("Devices")
            ]
        )
    ]
)
