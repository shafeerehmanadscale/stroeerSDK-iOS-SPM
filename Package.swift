// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "YieldloveAdIntegration",
    platforms: [.iOS(.v15)],

    // Third-party packages auto-pulled via overlay targets
    dependencies: [
        .package(url: "https://github.com/prebid/prebid-mobile-ios.git", exact: "3.1.0"),
        .package(url: "https://github.com/googleads/swift-package-manager-google-mobile-ads.git",
                 exact: "12.2.0"),
        .package(url: "https://github.com/mxcl/PromiseKit.git",
                 exact: "8.0.0"),
        .package(url: "https://github.com/SourcePointUSA/ios-cmp-app.git", exact: "7.7.7")
    ],

    // Public products (match your subspecs)
    products: [
        // Core
        .library(name: "YieldloveAdIntegration",
                 targets: ["YieldloveAdIntegration", "YLCoreSupport"]),
        // Consent (pulls Core + CMP automatically)
        .library(name: "YieldloveConsent",
                 targets: ["YieldloveConsent", "YLConsentSupport"]),
        // Confiant (pulls Core automatically; publisher adds Confiant SDK separately)
        .library(name: "YieldloveConfiant",
                 targets: ["YieldloveConfiant", "YLConfiantSupport"])
    ],

    targets: [
        // ---- Your binary XCFrameworks (URLs will point to your GitHub Release in step 3) ----
        .binaryTarget(
            name: "YieldloveAdIntegration",
            url: "https://github.com/shafeerehmanadscale/stroeerSDK-iOS-SPM/releases/download/v10.2.0/YieldloveAdIntegration.xcframework.zip",
            checksum: "55089f00165ee42452d87dc124664557b54ab0d5972fb6258cf65a8d82203537"
        ),
        .binaryTarget(
            name: "YieldloveConsent",
            url: "https://github.com/shafeerehmanadscale/stroeerSDK-iOS-SPM/releases/download/v10.2.0/YieldloveConsent.xcframework.zip",
            checksum: "542793c4b84112ad8d41c58d37c16e89fa246f69a56df967934f6ae3fb589782"
        ),
        .binaryTarget(
            name: "YieldloveConfiant",
            url: "https://github.com/shafeerehmanadscale/stroeerSDK-iOS-SPM/releases/download/v10.2.0/YieldloveConfiant.xcframework.zip",
            checksum: "49a92f851e25618cd3ba138c88f3493c873fc0e5d02db25d2d5b56a187ca5b8e"
        ),

        // ---- Overlay targets (no API; just wire dependencies) ----
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
        )
    ]
)
