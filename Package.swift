// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "bellande_internal_sensors_mobile_ios_api",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "bellande_internal_sensors_mobile_ios_api",
            targets: ["bellande_internal_sensors_mobile_ios_api"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "bellande_internal_sensors_mobile_ios_api",
            dependencies: []),
        .testTarget(
            name: "bellande_internal_sensors_mobile_ios_apiTests",
            dependencies: ["bellande_internal_sensors_mobile_ios_api"]),
    ]
)
