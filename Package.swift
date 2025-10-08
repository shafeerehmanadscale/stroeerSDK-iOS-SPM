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
        .package(url: "https://github.com/AddApptr/AATKitSPM.git", exact: "3.12.7"),
        .package(url: "https://github.com/googleads/swift-package-manager-google-mobile-ads.git", exact: "12.2.0"),
        .package(url: "https://github.com/mxcl/PromiseKit.git", exact: "8.2.0"),
        .package(url: "https://github.com/SourcePointUSA/ios-cmp-app.git", exact: "7.7.7"),
        .package(url: "https://github.com/prebid/prebid-mobile-ios.git", exact: "3.1.0")
    ],

    targets: [
        // ---- Remote binary XCFrameworks (fill URLs; checksums as provided) ----
        .binaryTarget(
            name: "YieldloveAdIntegration",
            url: "https://github.com/shafeerehmanadscale/stroeerSDK-iOS-SPM/releases/download/10.4.4/YieldloveAdIntegration.xcframework.zip",
            checksum: "6f3427f0d0c8a98d788bf96630325fbd771302cbbd1a77f0b8d01e0ff07385ae"
        ),
        .binaryTarget(
            name: "YieldloveConsent",
            url: "https://github.com/shafeerehmanadscale/stroeerSDK-iOS-SPM/releases/download/10.4.4/YieldloveConsent.xcframework.zip",
            checksum: "ea630fa8ea02751cadb04b71b562b6bb4eef46246001ba2198303104aa84e6e7"
        ),
        .binaryTarget(
            name: "YieldloveConfiant",
            url: "https://github.com/shafeerehmanadscale/stroeerSDK-iOS-SPM/releases/download/10.4.4/YieldloveConfiant.xcframework.zip",
            checksum: "e502b01cceb5a1fdf94cf3da4292ce2e7ce14303d05e3a17d79ba14ef8b65672"
        ),
        .binaryTarget(
            name: "YieldloveGravite",
            url: "https://github.com/shafeerehmanadscale/stroeerSDK-iOS-SPM/releases/download/10.4.4/YieldloveGravite.xcframework.zip",
            checksum: "b85816bc0a5172eabd55fdf05d823de73e8308c61ac6c5f86f46d42bd25e485a"
        ),
        .binaryTarget(
            name: "OMSDK_Prebidorg",
            path: "Frameworks/OMSDK_Prebidorg.xcframework"
        ),
        .binaryTarget(
            name: "XCPrebidMobile",
            path: "Frameworks/XCPrebidMobile.xcframework"
        ),
        
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
