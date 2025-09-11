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
            url: "https://github.com/shafeerehmanadscale/stroeerSDK-iOS-SPM/releases/download/10.2.5/YieldloveAdIntegration.xcframework.zip",
            checksum: "33fe376faad8344eaa4de49322cffc16c1cdd9662af2376e3de3f90fc3572038"
        ),
        .binaryTarget(
            name: "YieldloveConsent",
            url: "https://github.com/shafeerehmanadscale/stroeerSDK-iOS-SPM/releases/download/10.2.5/YieldloveConsent.xcframework.zip",
            checksum: "0e19e3b1e7926ed52c75fde337678c28111d1d4b8819e81b9a7e477580de875c"
        ),
        .binaryTarget(
            name: "YieldloveConfiant",
            url: "https://github.com/shafeerehmanadscale/stroeerSDK-iOS-SPM/releases/download/10.2.5/YieldloveConfiant.xcframework.zip",
            checksum: "96344558eeb96876f550c4a053085b88605da07c95791fb8e5f84935c39d5f73"
        ),
        .binaryTarget(
            name: "YieldloveGravite",
            url: "https://github.com/shafeerehmanadscale/stroeerSDK-iOS-SPM/releases/download/10.2.5/YieldloveGravite.xcframework.zip",
            checksum: "2b1598837f3f5a1b307ed4c0bd1e785e5ba3238d2137160a1f672272fcda76c5"
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
