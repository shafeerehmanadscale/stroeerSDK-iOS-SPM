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
            targets: ["YieldloveConsent",  "YLConsentSupport"]
        ),
        .library(
            name: "YieldloveConfiant",
            targets: ["YieldloveConfiant", "YLConfiantSupport"]
        ),
        .library(
            name: "YieldloveGravite",
            targets: ["YieldloveGravite",  "YLGraviteSupport"]
        )
    ],

    dependencies: [
        .package(url: "https://github.com/prebid/prebid-mobile-ios.git", exact: "3.1.0"),
        .package(url: "https://github.com/googleads/swift-package-manager-google-mobile-ads.git", exact: "12.2.0"),
        .package(url: "https://github.com/mxcl/PromiseKit.git", exact: "8.2.0"),
        .package(url: "https://github.com/SourcePointUSA/ios-cmp-app.git", exact: "7.7.8"),
        .package(url: "https://github.com/AddApptr/AATKitSPM", exact: "3.12.7")
    ],

    targets: [
        // ---- Remote binary XCFrameworks (fill URLs; checksums as provided) ----
        .binaryTarget(
            name: "YieldloveAdIntegration",
            url: "https://github.com/shafeerehmanadscale/stroeerSDK-iOS-SPM/releases/download/10.3.3/YieldloveAdIntegration.xcframework.zip",
            checksum: "929558b813f1c079d512d423d9da5e17076107c48a92cc31bf1355082b5fc3f3"
        ),
        .binaryTarget(
            name: "YieldloveConsent",
            url: "https://github.com/shafeerehmanadscale/stroeerSDK-iOS-SPM/releases/download/10.3.3/YieldloveConsent.xcframework.zip",
            checksum: "944ea4cfa8e363598168173fa6100f7cee82e01ff06fd276fe3e5775bb1387d3"
        ),
        .binaryTarget(
            name: "YieldloveConfiant",
            url: "https://github.com/shafeerehmanadscale/stroeerSDK-iOS-SPM/releases/download/10.3.5/YieldloveConfiant.xcframework.zip",
            checksum: "45fd953231cd38a34c3381ee0a25bc30f376a902cd732ff1b1a4ad3b8d9bd38a"
        ),
        .binaryTarget(
            name: "YieldloveGravite",
            url: "https://github.com/shafeerehmanadscale/stroeerSDK-iOS-SPM/releases/download/10.3.5/YieldloveGravite.xcframework.zip",
            checksum: "cf6c46840600219c496e772ecbd88940636115336f0b4e67a9438b3ebf0c0546"
        ),
        .binaryTarget(
            name: "OMSDK_Prebidorg",
            path: "Frameworks/OMSDK_Prebidorg.xcframework"
        ),

        .target(
            name: "YLCoreSupport",
            dependencies: [
                "YieldloveAdIntegration",
                "OMSDK_Prebidorg",
                .product(name: "PrebidMobile", package: "prebid-mobile-ios"),
                .product(name: "GoogleMobileAds", package: "swift-package-manager-google-mobile-ads"),
                .product(name: "PromiseKit", package: "PromiseKit"),
            ],
            path: "Sources/YLCoreSupport",
            sources: ["Shim.swift"]
        ),

        .target(
            name: "YLConsentSupport",
            dependencies: [
                "YieldloveConsent",
                "YieldloveAdIntegration",
                .product(name: "ConsentViewController", package: "ios-cmp-app"),
            ],
            path: "Sources/YLConsentSupport",
            sources: ["Shim.swift"]
        ),

        .target(
            name: "YLConfiantSupport",
            dependencies: [
                "YieldloveConfiant",
                "YieldloveAdIntegration"
            ],
            path: "Sources/YLConfiantSupport",
            sources: ["Shim.swift"]
        ),

        .target(
            name: "YLGraviteSupport",
            dependencies: [
                "YieldloveGravite",
                "YieldloveAdIntegration",
                .product(name: "AATKit-Core", package: "AATKitSPM"),
            ],
            path: "Sources/YLGraviteSupport",
            sources: ["Shim.swift"]
        )
    ]
)
