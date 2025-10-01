// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "YieldloveAdIntegration",
    platforms: [.iOS(.v15)],

    products: [
        .library(
            name: "YieldloveAdIntegration",
            targets: ["YieldloveAdIntegration", "YLCoreSupport"]
        )
    ],

    dependencies: [
        .package(url: "https://github.com/prebid/prebid-mobile-ios.git", exact: "3.1.0"),
        .package(url: "https://github.com/googleads/swift-package-manager-google-mobile-ads.git", exact: "12.2.0"),
        .package(url: "https://github.com/mxcl/PromiseKit.git", exact: "8.2.0"),
    ],

    targets: [
        // Your prebuilt SDK
        .binaryTarget(
            name: "YieldloveAdIntegration",
            url: "https://github.com/shafeerehmanadscale/stroeerSDK-iOS-SPM/releases/download/10.2.7/YieldloveAdIntegration.xcframework.zip",
            checksum: "235d4034cefa0e784dbc26d08524f0271aefeb2a83a87229238a9a0ccda8cba3"
        ),

        // Pulls in and links the SPM deps so the app only depends on one product
        .target(
            name: "YLCoreSupport",
            dependencies: [
                "YieldloveAdIntegration",
                .product(name: "GoogleMobileAds", package: "swift-package-manager-google-mobile-ads"),
                .product(name: "PrebidMobile", package: "prebid-mobile-ios"),
                .product(name: "PromiseKit", package: "PromiseKit")
            ],
            path: "Sources/YLCoreSupport",
            sources: ["Shim.swift"]
        )
    ]
)
