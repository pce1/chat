// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "VoiceStenogram",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "VoiceStenogram",
            targets: ["VoiceStenogram"]),
    ],
    targets: [
        .target(
            name: "VoiceStenogram",
            path: "VoiceStenogram"
        )
    ]
)
