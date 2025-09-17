
//  AATBridge.swift
//  Host App (adds this file)
//
//  NOTE: Keep this file in the APP target. Your XCFramework will discover it
//  via NSClassFromString("AATBridge") and never link AATKit itself.
//

//
//  AATBridge.swift
//  Host App
//

import Foundation
import UIKit
import AATKit
import YieldloveGravite

@objc(AATBridge) // global Obj-C name so your XCFramework can find it via NSClassFromString("AATBridge")
final class AATBridge: NSObject, AATBridgeProtocol {

    // Keep strong refs so delegates/placements aren’t deallocated
    private var strongDelegates: [AnyObject] = []
    private var interstitials: [String: AATFullscreenPlacement] = [:]
    private var didInit = false

    // MARK: - SDK lifecycle

    func initIfNeeded(options: [String : Any]?) {
        guard !didInit else { return }

        let cfg = AATConfiguration()

        // Optional knobs (you can pass these from your XCFramework via options)
        if let testId = (options?["testAccountId"] as? NSNumber)?.intValue
            ?? options?["testAccountId"] as? Int {
            cfg.testModeAccountId = NSNumber(value: testId)
        }
        if let altBundle = options?["alternativeBundleId"] as? String {
            cfg.alternativeBundleId = altBundle
        }

        // Log level (AATKit commonly exposes .debug / .info)
        let level: AATLogLevel = {
            switch (options?["logLevel"] as? String)?.lowercased() {
            case "debug": return .debug
            // Map unknowns (warning/error) to .info to avoid enum mismatches
            case "warning", "warn", "error": return .info
            default: return .info
            }
        }()
        AATSDK.setLogLevel(logLevel: level)

        // Consent: handled here in the host app
        cfg.consent = AATVendorConsent(delegate: self)

        AATSDK.initAATKit(with: cfg)
        didInit = true
        print("[AATBridge] AATSDK initialized (logLevel=\(level))")
    }

    func controllerViewDidAppear(_ vc: UIViewController) {
        AATSDK.controllerViewDidAppear(controller: vc)
    }

    func controllerViewWillDisappear() {
        AATSDK.controllerViewWillDisappear()
    }

    // MARK: - Targeting / debug / version

    func setTargetingInfo(_ info: [String : [String]]) {
        AATSDK.setTargetingInfo(info: info)
    }

    func getVersion() -> String {
        AATSDK.getVersion()
    }

    func enableDebugScreen() {
        AATSDK.enableDebugScreen()
    }

    func getDebugInfoString() -> String? {
        if let dbg = AATSDK.getDebugInfoObject() {
            // Safe summary — avoids depending on AATDebugInfo’s exact shape
            return String(describing: dbg)
        }
        return nil
    }

    // MARK: - Banner cache

    func createBannerCache(
        placement: String,
        sizes: [String],
        onFirstBannerLoaded: @escaping () -> Void
    ) -> AnyObject? {

        let conf = AATBannerCacheConfiguration(placementName: placement, size: 1)

        // Request + size mapping (strings like "320x50" -> AATBannerSize)
        let req = AATBannerRequest(delegate: self)
        let mapped = Set(sizes.compactMap { AATBannerSize(rawValue: $0) })
        if !mapped.isEmpty { req.setRequestBannerSizes(sizes: mapped) }

        conf.requestConfiguration = req
        conf.bannerRequestDelegate = self

        // Cache delegate that forwards firstBannerLoaded to your XCFramework
        let del = BridgeBannerCacheDelegate(onFire: onFirstBannerLoaded)
        strongDelegates.append(del)             // keep alive
        conf.delegate = del

        if let cache = AATSDK.createBannerCache(configuration: conf) {
            return cache
        } else {
            print("[AATBridge] Failed to create AATBannerCache for '\(placement)'")
            return nil
        }
    }

    func consume(from cache: AnyObject) -> UIView? {
        (cache as? AATBannerCache)?.consume() as? UIView
    }

    // MARK: - Interstitials

    func interstitialPrepare(placement: String) {
        if interstitials[placement] != nil { return }
        guard let p = AATSDK.createFullscreenPlacement(name: placement) else {
            print("[AATBridge] Failed to create fullscreen placement '\(placement)'")
            return
        }
        p.delegate = self
        p.startAutoReload() // keep it warm
        interstitials[placement] = p
    }

    func interstitialHasAd(placement: String) -> Bool {
        interstitials[placement]?.hasAd() ?? false
    }

    func interstitialShow(placement: String) {
        guard let p = interstitials[placement] else {
            print("[AATBridge] No interstitial for '\(placement)'")
            return
        }
        if p.hasAd() {
            p.show()
        } else {
            print("[AATBridge] Interstitial not ready for '\(placement)'")
        }
    }
}

// MARK: - Minimal helpers / delegates

private final class BridgeBannerCacheDelegate: NSObject, AATBannerCacheDelegate {
    private let onFire: () -> Void
    init(onFire: @escaping () -> Void) { self.onFire = onFire }

    // Exact selector without colon
    @objc dynamic func firstBannerLoaded() { onFire() }

    // Some AATKit builds call firstBannerLoaded: (with a param). Keep selector alive.
    @objc(firstBannerLoaded:)
    @available(*, unavailable)
    dynamic func firstBannerLoaded_bridge(_ any: Any?) {
        firstBannerLoaded()
    }
}

extension AATBridge: AATBannerRequestDelegate {
    func shouldUseTargeting(for request: AATBannerRequest, network: AATAdNetwork) -> Bool { true }
}

extension AATBridge: AATFullscreenPlacementDelegate {
    func aatPauseForAd(placement: AATPlacement) {
        print("[AATBridge] interstitial pause \(placement.getName())")
    }
    func aatHaveAd(placement: AATPlacement) {
        print("[AATBridge] interstitial ready \(placement.getName())")
    }
    func aatNoAd(placement: AATPlacement) {
        print("[AATBridge] interstitial no ad \(placement.getName())")
    }
    func aatAdCurrentlyDisplayed(placement: AATPlacement) {
        print("[AATBridge] interstitial displayed \(placement.getName())")
    }
    func aatResumeAfterAd(placement: AATPlacement) {
        print("[AATBridge] interstitial resume \(placement.getName())")
    }
}

// MARK: - Consent (handled in host app)

extension AATBridge: AATVendorConsentDelegate {

    // Mapping of AATKit networks -> IAB TCF vendor IDs
    private static let vendorIds: [AATAdNetwork: Int] = [
        .ADMOB: 755,
        .AMAZONHB: 793,
        .APPLOVIN: 333,
        .APPNEXUS: 32,
        .CRITEOSDK: 91,
        .DFP: 755,
        .FACEBOOK: 804,
        .FEEDAD: 781,
        .INMOBI: 333,
        .KIDOZ: 1278,
        .MINTEGRAL: 867,
        .OGURY: 31,
        .PUBNATIVE: 82,
        .SMAATO: 82,
        .SMARTAD: 82,
        .TAPPX: 628,
        .TEADS: 132,
        .UNITY: 1126,
        .YOC: 154,
        .VUNGLE2: 667,
        .SUPERAWESOME: 858,
        .ADMOBBIDDING: 755
    ]

    public func getConsentForNetwork(_ network: AATAdNetwork) -> NonIABConsent {
        guard let vendorId = Self.vendorIds[network] else { return .unknown }

        switch SimpleTCF.vendorConsent(vendorId: vendorId) {
        case .obtained: return .obtained
        case .withheld: return .withheld
        case .unknown:  return .unknown
        }
    }

    public func getConsentForAddapptr() -> NonIABConsent {
        // Your previous implementation returned .obtained
        return .obtained
    }

    /// Minimal, dependency-free TCF2 reader:
    /// - Prefer the CMP-provided "IABTCF_VendorConsents" bitstring (fast & simple)
    /// - If missing/invalid, fall back to `.unknown`
    private enum VendorDecision { case obtained, withheld, unknown }

    private enum SimpleTCF {
        static func vendorConsent(vendorId: Int) -> VendorDecision {
            // 1) Try the explicit bitstring if the CMP stores it (many do)
            if let bits = UserDefaults.standard.string(forKey: "IABTCF_VendorConsents"),
               vendorId > 0, vendorId <= bits.count {
                let idx = bits.index(bits.startIndex, offsetBy: vendorId - 1)
                return bits[idx] == "1" ? .obtained : .withheld
            }

            // 2) (Optional) Try to read the core TC string here if you need to be stricter.
            // Keeping it simple: return unknown if we can't determine.
            return .unknown
        }
    }
}

