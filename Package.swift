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
        .package(url: "https://github.com/SourcePointUSA/ios-cmp-app.git", exact: "7.7.7"),
        .package(url: "https://github.com/AddApptr/AATKitSPM", exact: "3.12.7")
    ],

    targets: [
        // ---- Remote binary XCFrameworks (fill URLs; checksums as provided) ----
        .binaryTarget(
            name: "YieldloveAdIntegration",
            url: "https://github.com/shafeerehmanadscale/stroeerSDK-iOS-SPM/releases/download/10.4.0/YieldloveAdIntegration.xcframework.zip",
            checksum: "e0a9eaad84062dd25b58ddbbac9f17d16bd54213bde337f0b48e73909c5c7506"
        ),
        .binaryTarget(
            name: "YieldloveConsent",
            url: "https://github.com/shafeerehmanadscale/stroeerSDK-iOS-SPM/releases/download/10.4.0/YieldloveConsent.xcframework.zip",
            checksum: "f42331474ca300f7e31d6f51091d49fa6f8148b590636ff14e1510ba77899b90"
        ),
        .binaryTarget(
            name: "YieldloveConfiant",
            url: "https://github.com/shafeerehmanadscale/stroeerSDK-iOS-SPM/releases/download/10.4.0/YieldloveConfiant.xcframework.zip",
            checksum: "f2093920a631b13161d8493ced2e2c627e8da676351f2c7b81f0a69449fa93ee"
        ),
        .binaryTarget(
            name: "YieldloveGravite",
            url: "https://github.com/shafeerehmanadscale/stroeerSDK-iOS-SPM/releases/download/10.4.0/YieldloveGravite.xcframework.zip",
            checksum: "c5341b2d86a3265734222990b72ae5828610f76cee04c9a7653f2662c0b6a346"
        ),
        .binaryTarget(
            name: "GoogleMobileAds",
            path: "Frameworks/GoogleMobileAds.xcframework"
        ),
        .binaryTarget(
            name: "OMSDK_Prebidorg",
            path: "Frameworks/OMSDK_Prebidorg.xcframework"
        ),
        .binaryTarget(
            name: "XCPrebidMobile",
            path: "Frameworks/XCPrebidMobile.xcframework"
        ),
        .binaryTarget(
            name: "PromiseKit",
            path: "Frameworks/PromiseKit.xcframework"
        ),

        .target(
            name: "YLCoreSupport",
            dependencies: [
                "YieldloveAdIntegration",
                "GoogleMobileAds",
                "OMSDK_Prebidorg",
                "XCPrebidMobile",
                "PromiseKit"
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
