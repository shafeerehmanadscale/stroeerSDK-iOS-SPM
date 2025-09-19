// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "YieldloveAdIntegration",
    platforms: [.iOS(.v15)],

    // 1) Public products
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
        ),
        .library(
            name: "YieldloveGravite",
            targets: ["YLGraviteSupport", "YLCoreSupport"]
        )
    ],

    // 2) Third-party deps (fetched by overlay/support targets)
    dependencies: [
        .package(url: "https://github.com/prebid/prebid-mobile-ios.git", exact: "3.1.0"),
        .package(url: "https://github.com/googleads/swift-package-manager-google-mobile-ads.git", exact: "12.2.0"),
        .package(url: "https://github.com/mxcl/PromiseKit.git", exact: "8.0.0"),
        .package(url: "https://github.com/SourcePointUSA/ios-cmp-app",
                 .upToNextMinor(from: "7.7.7"))
    ],

    // 3) Targets
    targets: [
        // --- Binary XCFrameworks ---
        .binaryTarget(
            name: "YieldloveAdIntegration",
            url: "https://github.com/shafeerehmanadscale/stroeerSDK-iOS-SPM/releases/download/10.2.0/YieldloveAdIntegration.xcframework.zip",
            checksum: "fed5ad2d6be8da831bf180072a813e74fd57e08aa2bdf3bc28803ae586570834"
        ),
        .binaryTarget(
            name: "YieldloveConsent",
            url: "https://github.com/shafeerehmanadscale/stroeerSDK-iOS-SPM/releases/download/10.2.0/YieldloveConsent.xcframework.zip",
            checksum: "0e56f32c2d2b0c33f236baa5ac8715312cda70d35df8b60ee951d7bdcfeba797d"
        ),
        .binaryTarget(
            name: "YieldloveConfiant",
            url: "https://github.com/shafeerehmanadscale/stroeerSDK-iOS-SPM/releases/download/10.2.0/YieldloveConfiant.xcframework.zip",
            checksum: "6d7c52c2d2b0c33f236baa5ac8715312cda70d35df8b60ee951d7bdcfeba797d"
        ),

        // --- Overlay / support targets ---
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

        // --- Gravite as Swift sources (now includes ALL files under Sources/YLGraviteSupport) ---
        .target(
            name: "YLGraviteSupport",
            dependencies: [
                "YieldloveAdIntegration",
                "YLCoreSupport"
            ],
            path: "Sources/YLGraviteSupport"
        )
    ]
)
