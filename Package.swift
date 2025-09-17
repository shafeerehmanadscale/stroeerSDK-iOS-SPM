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
        .package(url: "https://github.com/AddApptr/AATKitSPM.git",
                         .upToNextMinor(from: "3.12.3"))
    ],

    // 3) Targets
    targets: [
        .binaryTarget(
            name: "YieldloveAdIntegration",
            url: "https://github.com/shafeerehmanadscale/stroeerSDK-iOS-SPM/releases/download/10.2.0/YieldloveAdIntegration.xcframework.zip",
            checksum: "e52577f89e3c6f88f3fcf65a63519ef117c069d3a3ca9e53e04c73e6924c0fb2"
        ),
        .binaryTarget(
            name: "YieldloveConsent",
            url: "https://github.com/shafeerehmanadscale/stroeerSDK-iOS-SPM/releases/download/10.2.0/YieldloveConsent.xcframework.zip",
            checksum: "82d802a040b4c3c72f02742bd39ff786d50a1ca0794662cdbaac843b20c3d737"
        ),
        .binaryTarget(
            name: "YieldloveConfiant",
            url: "https://github.com/shafeerehmanadscale/stroeerSDK-iOS-SPM/releases/download/10.2.0/YieldloveConfiant.xcframework.zip",
            checksum: "a360f196cd06c76dc66cb71296da4e0159858383c18b77d79ae28f144339c447"
        ),
        .binaryTarget(
            name: "YieldloveGravite",
            url: "https://github.com/shafeerehmanadscale/stroeerSDK-iOS-SPM/releases/download/10.2.0/YieldloveGravite.xcframework.zip",
            checksum: "e5e86845a0f331e17ae044a6d5d75d5172c110035389f7d46a658105cc6787b5"
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
            sources: ["Shim.swift", "AATBridge.swift"]
        )
    ]
)
