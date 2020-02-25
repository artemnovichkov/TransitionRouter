// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "TransitionRouter",
    products: [
        .library(
            name: "TransitionRouter",
            targets: ["TransitionRouter"]),
    ],
    targets: [
        .target(
            name: "TransitionRouter",
            path: "Sources"),
    ]
)