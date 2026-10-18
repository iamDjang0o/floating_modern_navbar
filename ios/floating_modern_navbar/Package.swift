// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "floating_modern_navbar",
    platforms: [.iOS("13.0")],
    products: [
        .library(name: "floating-modern-navbar", targets: ["floating_modern_navbar"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework")
    ],
    targets: [
        .target(
            name: "floating_modern_navbar",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework")
            ],
            cSettings: [.headerSearchPath("include/floating_modern_navbar")]
        )
    ]
)
