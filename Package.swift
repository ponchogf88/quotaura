// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Quotaura",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(name: "Quotaura", targets: ["QuotauraApp"])
    ],
    targets: [
        .executableTarget(
            name: "QuotauraApp",
            path: "Sources/QuotauraApp"
        ),
        .testTarget(
            name: "QuotauraTests",
            dependencies: ["QuotauraApp"],
            path: "Tests/QuotauraTests"
        )
    ]
)
