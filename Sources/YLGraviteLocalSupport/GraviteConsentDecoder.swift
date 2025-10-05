//
//  GraviteConsentDecoder.swift
//  GravitePlugin
//
//  Created by Hyungon Kim on 17/03/2025.
//

import Foundation
import AATKit
import YieldloveAdIntegration

class GraviteConsentDecoder {
    // Vendor ID mapping for known AdNetworks
    private static let VENDOR_IDS: [AATAdNetwork: Int] = [
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

    static func isVendorConsentGiven(adNetwork: AATAdNetwork) -> NonIABConsent {
        guard let vendorId = VENDOR_IDS[adNetwork] else {
            return .unknown
        }

        let consentString = UserDefaults.standard.string(forKey: "IABTCF_TCString") ?? ""
        return ConsentStringDecoder.isVendorConsentGiven(consentString: consentString, vendorId: vendorId) ? .obtained : .withheld
    }
}
