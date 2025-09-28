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
            targets: ["YieldloveConsent", "YLConsentSupport"]
        ),
        .library(
            name: "YieldloveConfiant",
            targets: ["YieldloveConfiant", "YLConfiantSupport"]
        ),
        .library(
            name: "YieldloveGravite2",
            targets: ["YLGraviteSupport2", "YLCoreSupport"]
        ),
        .library(
            name: "YieldloveGravite",
            targets: ["YLGraviteSupport", "YLCoreSupport"]
        )
    ],

    // 👇 No third-party packages here
    dependencies: [],

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
            checksum: "0e56f32aed00b81ec5da72d111ac5f832ce0b4a12a1c4d0d0fd4ed069af55667"
        ),
        .binaryTarget(
            name: "YieldloveConfiant",
            url: "https://github.com/shafeerehmanadscale/stroeerSDK-iOS-SPM/releases/download/10.2.0/YieldloveConfiant.xcframework.zip",
            checksum: "6d7c52c2d2b0c33f236baa5ac8715312cda70d35df8b60ee951d7bdcfeba797d"
        ),

        // --- Support targets (no external products) ---
        .target(
            name: "YLCoreSupport",
            dependencies: [
                "YieldloveAdIntegration"
            ],
            path: "Sources/YLCoreSupport",
            sources: ["Shim.swift"]
        ),
        .target(
            name: "YLConsentSupport",
            dependencies: [
                "YieldloveConsent",
                "YieldloveAdIntegration",
                "YLCoreSupport"
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
            name: "YLGraviteSupport2",
            dependencies: [
                "YieldloveAdIntegration",
                "YLCoreSupport"
            ],
            path: "Sources/YLGraviteSupport2",
            sources: ["Shim.swift"]
        ),
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
