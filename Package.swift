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
        .binaryTarget(
            name: "YieldloveAdIntegration",
            url: "https://github.com/shafeerehmanadscale/stroeerSDK-iOS-SPM/releases/download/10.2.0/YieldloveAdIntegration.xcframework.zip",
            checksum: "6f708e82d08bc640e38bdd5359224dbbc045b3c63ceec778a93c12fceac0260c"
        ),
        .binaryTarget(
            name: "YieldloveConsent",
            url: "https://github.com/shafeerehmanadscale/stroeerSDK-iOS-SPM/releases/download/10.2.0/YieldloveConsent.xcframework.zip",
            checksum: "1fbd5655c07325c70906bf58119a3e9d68ff3f629777270b5cb3223d6193ad04"
        ),
        .binaryTarget(
            name: "YieldloveConfiant",
            url: "https://github.com/shafeerehmanadscale/stroeerSDK-iOS-SPM/releases/download/10.2.0/YieldloveConfiant.xcframework.zip",
            checksum: "94ed8be662e4018be70df4a57c03066388cc7e1ac9bfb861920cf6991055ef61"
        ),
        .binaryTarget(
            name: "YieldloveGravite",
            url: "https://github.com/shafeerehmanadscale/stroeerSDK-iOS-SPM/releases/download/10.2.0/YieldloveGravite.xcframework.zip",
            checksum: "b71858fe4fd163f965a0c4d00f581c7120c8a014af74a46c089d6301c92d9d46"
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
