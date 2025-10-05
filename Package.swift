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
        ),
        .library(
            name: "YieldloveGraviteLocal",
            targets: ["YieldloveGraviteLocal"]
        )
    ],

    dependencies: [
        .package(url: "https://github.com/SourcePointUSA/ios-cmp-app.git", exact: "7.7.8"),
        .package(url: "https://github.com/AddApptr/AATKitSPM", exact: "3.12.7")
    ],

    targets: [
        // ---- Remote binary XCFrameworks (fill URLs; checksums as provided) ----
        .binaryTarget(
            name: "YieldloveAdIntegration",
            url: "https://github.com/shafeerehmanadscale/stroeerSDK-iOS-SPM/releases/download/10.3.7/YieldloveAdIntegration.xcframework.zip",
            checksum: "89a11ee57428ae1f142fa9444fc9cc9a0cbd3012e54a998cff6c0b779d223f21"
        ),
        .binaryTarget(
            name: "YieldloveConsent",
            url: "https://github.com/shafeerehmanadscale/stroeerSDK-iOS-SPM/releases/download/10.3.7/YieldloveConsent.xcframework.zip",
            checksum: "a245c1444a5bfced887fe28892c484dce41f42e40e18840aa5ddcf22cb58746d"
        ),
        .binaryTarget(
            name: "YieldloveConfiant",
            url: "https://github.com/shafeerehmanadscale/stroeerSDK-iOS-SPM/releases/download/10.3.7/YieldloveConfiant.xcframework.zip",
            checksum: "a314be823ea66d1c47edffb48309eeef618aac106f711d34b47d04117047a799"
        ),
        .binaryTarget(
            name: "YieldloveGravite",
            url: "https://github.com/shafeerehmanadscale/stroeerSDK-iOS-SPM/releases/download/10.3.7/YieldloveGravite.xcframework.zip",
            checksum: "ae97daf0a289625c321d385caabfd04df4f238b8dbd3c918f7ccd20d362621bc"
        ),
        .binaryTarget(
            name: "OMSDK_Prebidorg",
            path: "Frameworks/OMSDK_Prebidorg.xcframework"
        ),

        .target(
            name: "YLCoreSupport",
            dependencies: [
                "YieldloveAdIntegration",
                "OMSDK_Prebidorg"
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
        ),
        .target(
            name: "YieldloveGraviteLocal",
            dependencies: [
                .product(name: "AATKit-Core", package: "AATKitSPM"),
                "YieldloveAdIntegration"
            ],
            path: "Sources/YLGraviteLocalSupport"
        )
    ]
)
