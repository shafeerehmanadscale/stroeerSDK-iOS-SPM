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
        
        .library(name: "YieldloveConsent",  targets: ["Consent"]),
        .library(name: "YieldloveGravite",  targets: ["Gravite"]),
        .library(name: "YieldloveConfiant", targets: ["Confiant"]),
    ],

    // Added exact-version dependencies
    dependencies: [
        .package(url: "https://github.com/prebid/prebid-mobile-ios.git", exact: "3.1.0"),
        .package(url: "https://github.com/googleads/swift-package-manager-google-mobile-ads.git", exact: "12.2.0"),
        .package(url: "https://github.com/mxcl/PromiseKit.git", exact: "8.2.0"),
        .package(url: "https://github.com/SourcePointUSA/ios-cmp-app.git", exact: "7.7.8")
    ],

    targets: [
        // --- Binary XCFrameworks ---
        .binaryTarget(
            name: "YieldloveAdIntegration",
            url: "https://github.com/shafeerehmanadscale/stroeerSDK-iOS-SPM/releases/download/10.3.3/YieldloveAdIntegration.xcframework.zip",
            checksum: "f78667fc83a5053f3c7487c9d1081b64fbd230c06ec9e4d41294cf17c9a11757"
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
            name: "Consent",
            dependencies: [
                "YieldloveAdIntegration",
                .product(name: "ConsentViewController", package: "ios-cmp-app")
            ],
            path: "Sources/Consent"
        ),

        // Gravite plugin → depends on Core (add AATKit when you connect it)
        .target(
            name: "Gravite",
            dependencies: [
                "YieldloveAdIntegration"
            ],
            path: "Sources/Gravite"
        ),

        // Confiant plugin → depends on Core
        .target(
            name: "Confiant",
            dependencies: [
                "YieldloveAdIntegration"
            ],
            path: "Sources/Confiant"
        )
    ]
)
