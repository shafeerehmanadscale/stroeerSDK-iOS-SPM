//
//  GraviteBannerCache.swift
//  YieldloveAdIntegration
//
//  Created by Hyungon Kim on 29/07/2024.
//
import Foundation
import AATKit
import UIKit
import YieldloveAdIntegration
import GoogleMobileAds

class GraviteBannerSet {
    var bannerCache: AATBannerCache
    var bannerDelegate: GraviteBannerDelegate?
    
    init(_ bannerCache: AATBannerCache, _ bannerDelegate: GraviteBannerDelegate) {
        self.bannerCache = bannerCache
        self.bannerDelegate = bannerDelegate
    }
}

public class GraviteBanner : IBackFillBanner {
    private var cacheTable: Dictionary<String, GraviteBannerSet> = Dictionary()
        
    private var cacheSize: Int = 1
    private var stroeerToGravitePlacementMapTable : Dictionary<String, String>? = nil
    private var loadedDelegate: IFirstBannerLoaded? = nil;
    
    /**
     Load Banner
     */
    public func loadBanner(config: GraviteBannerConfig) -> Void {
        if let ylAdUnitData = config.ylAdUnitData, let viewController = config.viewController {
            let loaded = config.loaded
            let placementName = getPlacementNameForGravite(ylAdUnitData: ylAdUnitData)
            
            print("[Shafee - Gravite] view did appear FROM LOAD \(viewController.description) [END]")
            //YLAATProtocolLocator.shared.controllerViewDidAppear(controller: viewController)
            AATSDK.controllerViewDidAppear(controller: viewController)
            if cacheTable[placementName] == nil
            {
                
                let configuration = AATBannerCacheConfiguration(placementName: placementName, size: cacheSize)
                let request = AATBannerRequest(delegate: self)
                self.loadedDelegate = loaded
                
                // Convert AdSize and then set the sizes in Gravite
                let aatSizeConversion = GraviteBanner.convertAdSizes(bannerSizes: ylAdUnitData.bannerSizes)
                if (aatSizeConversion.count > 0)
                {
                    request.setRequestBannerSizes(sizes: Set(aatSizeConversion))
                }
                let bannerDelegate = GraviteBannerDelegate(loaded)
                configuration.delegate = bannerDelegate
                configuration.requestConfiguration = request
                configuration.bannerRequestDelegate = self
                
                DispatchQueue.main.async {
                    if let bannerCache = AATSDK.createBannerCache(configuration: configuration) {
                       // YLAATProtocolLocator.shared.createBannerCache(configuration: configuration)
                        let bannerSet = GraviteBannerSet(bannerCache, bannerDelegate)
                        self.cacheTable[placementName] = bannerSet
                        self.cacheTable[placementName]!.bannerCache.impressionDelegate = self
                        SLogger.i("\(GraviteConstants.logTag) A banner is created : \(placementName)")
                    }
                    else
                    {
                        SLogger.i("\(GraviteConstants.logTag) failed to create banner : \(placementName)")
                    }
                }
            }
            else
            {
                print("[Shafee - Gravite] cache table is not nil [END]")
                cacheTable[placementName]?.bannerDelegate = nil // We don't need this anymore
            }
        }
    }
    
    private func getPlacementNameForGravite(ylAdUnitData: YLAdUnitData) -> String {
        return GraviteHelper.convertAdslot(placementTable:stroeerToGravitePlacementMapTable, adSlot: ylAdUnitData.getPlacementName())
    }
    
    public func getBanner(ylAdUnitData: YLAdUnitData, adContainerView: UIView) ->UIView?
    {
        let placementName = getPlacementNameForGravite(ylAdUnitData: ylAdUnitData)
        
        print("[Shafee - Gravite] Placement Name: \(placementName) [END]")
        print("[Shafee - Gravite] cacheTable: \(cacheTable) [END]")
        
        if let adView = cacheTable[placementName]?.bannerCache.consume() {
            
            SLogger.i("\(GraviteConstants.logTag) banner \(ylAdUnitData.adUnit) is loaded")
            
            
            return adView as UIView
        }
        else
        {
            SLogger.i("\(GraviteConstants.logTag) banner \(ylAdUnitData.adUnit) is not loaded. Gravite doesn't return the ad. This is because of Gravite doesn't have ad or Grviate setting is set correctly. Please check the the log or the Gravite settings if this error persists")
            return nil
        }
    }
    
    /**
     Convert the adSize in Prebid to the adSize in Gravite
     AdSize not supported by Grivate will be ignored. ex) customSize
     */
    private class func convertAdSizes(bannerSizes: [AdSize]) -> [AATBannerSize]
    {
        var aatSizeConversion : [AATBannerSize] = []
        for adSize in bannerSizes
        {
            if let bannerSize = AATBannerSize(rawValue: "\(Int(adSize.size.width))x\(Int(adSize.size.height))") {
                aatSizeConversion.append(bannerSize)
            }
        }
        return aatSizeConversion
    }
    
    func setCacheSize(cacheSize: Int)
    {
        self.cacheSize = cacheSize
    }
    
    func setPlacementMapTable(stroeerToGravite:Dictionary<String,String>?)
    {
        stroeerToGravitePlacementMapTable = stroeerToGravite
    }
}

class GraviteBannerDelegate: AATBannerCacheDelegate {
    var loadedDelegate : IFirstBannerLoaded?
    
    init(_ loadedDelegate: IFirstBannerLoaded?) {
        self.loadedDelegate = loadedDelegate
    }
    
    public func firstBannerLoaded() {
        print("[Shafee - Gravite] onFirstBannerLoaded DELEGATE [END]")
        //YLAATProtocolLocator.shared.firstBannerLoaded()
        loadedDelegate?.onFirstBannerLoaded()
    }
}

extension GraviteBanner: AATBannerRequestDelegate {
    public func shouldUseTargeting(for request: AATBannerRequest, network: AATAdNetwork) -> Bool {
        return true
    }
}

extension GraviteBanner: AATImpressionDelegate {
    public func didCountImpression(placement: AATKit.AATPlacement?, _ impression: AATKit.AATImpression) {
    }
}
