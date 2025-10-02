// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "YieldloveAdIntegration",
    platforms: [.iOS(.v15)],

    products: [
        .library(
            name: "YieldloveAdIntegration",
            targets: ["YieldloveAdIntegration", "YLCoreSupport"]
        ),
        .library(
            name: "YieldloveConsent",
            targets: ["YieldloveConsent", "YLConsentSupport"]
        ),
        .library(
            name: "YieldloveConfiant",
            targets: ["YieldloveConfiant", "YLConfiantSupport"]
        )
    ],

    // Added exact-version dependencies
    dependencies: [
        .package(url: "https://github.com/prebid/prebid-mobile-ios.git", exact: "3.1.0"),
        .package(url: "https://github.com/googleads/swift-package-manager-google-mobile-ads.git", exact: "12.2.0"),
        .package(url: "https://github.com/mxcl/PromiseKit.git", exact: "8.2.0"),
        .package(url: "https://github.com/SourcePointUSA/ios-cmp-app.git", exact: "7.7.8"),
        .package(url: "https://github.com/AddApptr/AATKitSPM", exact: "3.12.7")
    ],

    targets: [
        // --- Binary XCFrameworks ---
        .binaryTarget(
            name: "YieldloveAdIntegration",
            url: "https://github.com/shafeerehmanadscale/stroeerSDK-iOS-SPM/releases/download/10.3.1/YieldloveAdIntegration.xcframework.zip",
            checksum: "440abd3e9e9bb5cb4585b7a7555764caf3e4c0110956ae6df49f39777a5f62a9"
        ),
        .binaryTarget(
            name: "YieldloveConsent",
            url: "https://github.com/shafeerehmanadscale/stroeerSDK-iOS-SPM/releases/download/10.3.1/YieldloveConsent.xcframework.zip",
            checksum: "c5a874fe8b08176712c7cfb34899dde3839660b37d28b4b52f953599431703bf"
        ),
        .binaryTarget(
            name: "YieldloveConfiant",
            url: "https://github.com/shafeerehmanadscale/stroeerSDK-iOS-SPM/releases/download/10.3.1/YieldloveConfiant.xcframework.zip",
            checksum: "487ed39af929dc942a50a9c074f1c8d7108fca8f4ea46cc2b8a67215a63d5af1"
        ),
        .binaryTarget(
            name: "YieldloveGravite",
            url: "https://github.com/shafeerehmanadscale/stroeerSDK-iOS-SPM/releases/download/10.3.1/YieldloveGravite.xcframework.zip",
            checksum: "13aef4ad8b9cc3473fc21ab936d685c88b06a0eede7ddc61cb69db7cc4b53c09"
        ),

        // --- Support targets (now pull in required products) ---
        .target(
            name: "YLCoreSupport",
            dependencies: [
                "YieldloveAdIntegration",
                .product(name: "PrebidMobile", package: "prebid-mobile-ios"),
                .product(name: "GoogleMobileAds", package: "swift-package-manager-google-mobile-ads"),
                .product(name: "PromiseKit", package: "PromiseKit")
            ],
            path: "Sources/YLCoreSupport",
            sources: ["Shim.swift"]
        ),
        .target(
            name: "YLConsentSupport",
            dependencies: [
                "YieldloveConsent",
                "YieldloveAdIntegration",
                "YLCoreSupport",
                .product(name: "ConsentViewController", package: "ios-cmp-app")
            ],
            path: "Sources/YLConsentSupport",
            sources: ["Shim.swift"]
        ),
        .target(
            name: "YLConfiantSupport",
            dependencies: [
                "YieldloveConfiant",
                "YieldloveAdIntegration",
                "YLCoreSupport"
            ],
            path: "Sources/YLConfiantSupport",
            sources: ["Shim.swift"]
        ),
        .target(
            name: "YLGraviteSupport2",
            dependencies: [
                "YieldloveGravite",
                "YieldloveAdIntegration",
                "YLCoreSupport",
                .product(name: "AATKit-Core", package: "AATKitSPM")
            ],
            path: "Sources/YLConsentSupport",
            sources: ["Shim.swift"]
        )
    ]
)
