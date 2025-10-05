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
        .package(url: "https://github.com/SourcePointUSA/ios-cmp-app.git", exact: "7.7.7"),
        .package(url: "https://github.com/AddApptr/AATKitSPM", exact: "3.12.7")
    ],

    targets: [
        // ---- Remote binary XCFrameworks (fill URLs; checksums as provided) ----
        .binaryTarget(
            name: "YieldloveAdIntegration",
            url: "https://github.com/shafeerehmanadscale/stroeerSDK-iOS-SPM/releases/download/10.3.8/YieldloveAdIntegration.xcframework.zip",
            checksum: "381b91b32ae685f9cbd0aae510cdaf94fdc30fc2a9bf970fff60d7db65d70228"
        ),
        .binaryTarget(
            name: "YieldloveConsent",
            url: "https://github.com/shafeerehmanadscale/stroeerSDK-iOS-SPM/releases/download/10.3.8/YieldloveConsent.xcframework.zip",
            checksum: "52d073efb0cba9268f3ce30cca579b9b29f76c097395267877b03720a9d0fbe4"
        ),
        .binaryTarget(
            name: "YieldloveConfiant",
            url: "https://github.com/shafeerehmanadscale/stroeerSDK-iOS-SPM/releases/download/10.3.8/YieldloveConfiant.xcframework.zip",
            checksum: "c4a0a8b7c5a973484da357256daf05950352219e8743f74c38e96dde10226b68"
        ),
        .binaryTarget(
            name: "YieldloveGravite",
            url: "https://github.com/shafeerehmanadscale/stroeerSDK-iOS-SPM/releases/download/10.3.8/YieldloveGravite.xcframework.zip",
            checksum: "7ce93a6e27479b69fb477c253ef96693e262b6f6dde8dbc3ce6d9210c8e7022a"
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
