// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "YieldloveAdIntegration",
    platforms: [.iOS(.v15)],

    // 1) Public products
    products: [
        // Core (also pulls Prebid 3.1.0, GMA 12.2.0, PromiseKit 8.0.0 via overlay)
        .library(
            name: "YieldloveAdIntegration",
            targets: ["YieldloveAdIntegration", "YLCoreSupport"]
        ),
        // Consent (pulls Core + CMP 7.7.7)
        .library(
            name: "YieldloveConsent",
            targets: ["YieldloveConsent", "YLConsentSupport"]
        ),
        // Confiant (pulls Core only; publisher adds Confiant SDK)
        .library(
            name: "YieldloveConfiant",
            targets: ["YieldloveConfiant", "YLConfiantSupport"]
        ),
        // Gravite (pulls Core + AATKit via overlay)
        .library(
            name: "YieldloveGravite",
            targets: ["YieldloveGravite", "YLGraviteSupport"]
        )
    ],

    // 2) Third-party package deps (fetched by the overlay targets)
    dependencies: [
        .package(url: "https://github.com/prebid/prebid-mobile-ios.git", exact: "3.1.0"),
        .package(url: "https://github.com/googleads/swift-package-manager-google-mobile-ads.git", exact: "12.2.0"),
        .package(url: "https://github.com/mxcl/PromiseKit.git", exact: "8.0.0"),
        .package(url: "https://github.com/SourcePointUSA/ios-cmp-app",
                 .upToNextMinor(from: "7.7.7")),
        // AATKit for Gravite. If your URL/product differs, adjust both here and in YLGraviteSupport.
        .package(url: "https://github.com/AddApptr/AATKitSPM.git",
                 .upToNextMinor(from: "3.12.3"))
    ],

    // 3) Targets
    targets: [
        // --- Binary XCFrameworks (GitHub Release 10.2.2) ---
        .binaryTarget(
            name: "YieldloveAdIntegration",
            url: "https://github.com/shafeerehmanadscale/stroeerSDK-iOS-SPM/releases/download/10.2.2/YieldloveAdIntegration.xcframework.zip",
            checksum: "55089f00165ee42452d87dc124664557b54ab0d5972fb6258cf65a8d82203537"
        ),
        .binaryTarget(
            name: "YieldloveConsent",
            url: "https://github.com/shafeerehmanadscale/stroeerSDK-iOS-SPM/releases/download/10.2.2/YieldloveConsent.xcframework.zip",
            checksum: "542793c4b84112ad8d41c58d37c16e89fa246f69a56df967934f6ae3fb589782"
        ),
        .binaryTarget(
            name: "YieldloveConfiant",
            url: "https://github.com/shafeerehmanadscale/stroeerSDK-iOS-SPM/releases/download/10.2.2/YieldloveConfiant.xcframework.zip",
            checksum: "49a92f851e25618cd3ba138c88f3493c873fc0e5d02db25d2d5b56a187ca5b8e"
        ),
        .binaryTarget(
            name: "YieldloveGravite",
            url: "https://github.com/shafeerehmanadscale/stroeerSDK-iOS-SPM/releases/download/10.2.2/YieldloveGravite.xcframework.zip",
            checksum: "bdec9b362afdff07034ea056ada577c7bb4f2ae3e43bfcd6f4ce7c685e8a61e2"
        ),

        // --- Overlay “glue” targets (no API; just pull deps) ---
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
            name: "YLGraviteSupport",
            dependencies: [
                "YieldloveGravite",
                "YieldloveAdIntegration",
                "YLCoreSupport",
                .product(name: "AATKit-Core", package: "AATKitSPM")
            ],
            path: "Sources/YLGraviteSupport",
            sources: ["Shim.swift"]
        )
    ]
)
