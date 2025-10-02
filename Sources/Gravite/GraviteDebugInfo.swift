//
//  GraviteDebugInfo.swift
//  GravitePlugin
//
//  Created by Hyungon Kim on 13/05/2025.
//

import Foundation
import AATKit
import YieldloveAdIntegration

public class GraviteDebugInfo : IDebugInfo {
    
    let adSourceInfo: AdSourceInfo
    
    init(sourceInfo: AdSourceInfo) {
        self.adSourceInfo = sourceInfo
    }
    
    public func toString() -> NSAttributedString {
        guard let info = AATSDK.getDebugInfoObject() else {
            return NSAttributedString(string:"Gravite debug information is empty")
        }

        var output = """
        AATDebugInfo {
          testBundleId = '\(safe(info.testBundleId))'
          testId = '\(safe(info.testId))'
          consentInfo = '\(safe(info.consentInfo))'
          availableAdNetworks = \(safeArray(info.availableAdNetworks))
          disabledAdNetworks = \(safeArray(info.disabledAdNetworks))
          removedAdNetworks = \(safeArray(info.removedAdNetworks))
          extraSDK = \(safeArray(info.extraSDK))
          deviceType = '\(info.deviceType)'
          idfaString = '\(safe(info.idfaString))'
        """

        output += getPlacementDebugInfoString(info.placementDebugInfo)

        output += "\n}"

        return NSAttributedString(string: output)
    }

    private func getPlacementDebugInfoString(_ placements: [AATDebugInfo.PlacementDebugInfo]) -> String {
        var output = "\n  placementDebugInfo = [\n"

        for (i, placement) in placements.enumerated() {
            output += """
              PlacementDebugInfo [\(i)] {
                placementName = '\(placement.placementName)'
                placementType = '\(placement.placementType)'
                bannerAutoReloadInterval = \(placement.bannerAutoReloadInterval)
                initialDelay = \(placement.initialDelay)
                remainingTime = \(placement.remainingTime)
                isLoadingNewAd = \(placement.isLoadingNewAd)
                isAdQualityActive = \(placement.isAdQualityActive)
                loadedAds = \(safeArray(placement.loadedAds))
                lastShownAd = \(safe(placement.lastShownAd))
                activeFrequencyCapping = \(getFrequencyCappingString(placement.activeFrequencyCapping))
              }

            """
        }

        output += "  ]\n"
        return output
    }

    private func getFrequencyCappingString(_ fc: AATDebugInfo.PlacementDebugInfo.FrequencyCappingDebugInfo?) -> String {
        guard let fc = fc else { return "null" }

        return """
        FrequencyCappingDebugInfo {
                  maxImpressionsPerSession = \(fc.maxImpressionsPerSession)
                  maxImpressionsPerHour = \(fc.maxImpressionsPerHour)
                  maxImpressionsPerDay = \(fc.maxImpressionsPerDay)
                  maxImpressionsPerWeek = \(fc.maxImpressionsPerWeek)
                  maxImpressionsPerMonth = \(fc.maxImpressionsPerMonth)
                  minTimeBetweenImpressions = \(fc.minTimeBetweenImpressions)
              }
        """
    }

    
    public var debugInfo: [String: Any] = [:]
    

    private func safe(_ value: Any?) -> String {
        if let v = value {
            return String(describing: v)
        }
        return "null"
    }

    private func safeArray<T>(_ array: [T]?) -> String {
        guard let array = array else { return "null" }
        return "[" + array.map { String(describing: $0) }.joined(separator: ", ") + "]"
    }

    public func getAdSourceInfo() -> AdSourceInfo {
        return adSourceInfo
    }

    public func getPublisherCallString() -> String {
        return "Gravite"
    }

    public func getServedInTime() -> Double {
        return 0
    }
}
