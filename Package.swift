// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftMapReduce",
    products: [
        .library(name: "MapReduce", targets: ["MapReduce"]),
        .library(name: "MapReduceAlgo", targets: ["MapReduceAlgo"]),
        .executable(name: "MapReduceRunner", targets: ["MapReduceRunner"]),
    ],
    dependencies: [
        .package(url: "https://github.com/gavrilaf/SwiftPerfTool.git", from: "0.1.0"),
    ],
    targets: [
        .target(name: "MapReduce", dependencies: []),
        .target(name: "MapReduceAlgo", dependencies: ["MapReduce"]),
        .target(name: "MapReduceRunner", dependencies: ["MapReduceAlgo", "SwiftPerfTool"]),
        .testTarget(name: "MapReduceTests", dependencies: ["MapReduce", "MapReduceAlgo"]),
    ]
)
