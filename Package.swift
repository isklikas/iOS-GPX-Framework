// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GPX",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "GPX",
            targets: ["GPX"]),
    ],
    dependencies: [
        // No Dependencies
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "GPX",
            dependencies: []),
        .testTarget(
            name: "GPXTests",
            dependencies: ["GPX"],
            resources: [
                    // Copy Tests/GPXTests/*.gpx files as-is.
                    // Use to retain files.
                    // Will be at top level in bundle.
                    .copy("mystic_basin_trail.gpx"),
                    .copy("sample.gpx"),
            ]
        ),
    ]
)
