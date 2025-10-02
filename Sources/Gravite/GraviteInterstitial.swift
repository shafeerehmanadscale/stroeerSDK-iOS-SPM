//
//  GraviteInterstitial.swift
//  YieldloveAdIntegration
//
//  Created by Hyungon Kim on 29/07/2024.
//
import Foundation
import AATKit
import UIKit
import YieldloveAdIntegration

class InterstitialSet{
    var isShowCalled = false
    var isReady = false
    var interstitialAd: AATFullscreenPlacement
    init(_ interstitialAd: AATFullscreenPlacement){
        self.interstitialAd = interstitialAd
    }
}

class GraviteInterstitial : IBackFillInterstitial{
    
    private var interstitialDelegate: YLInterstitialAdDelegate?
    private var stroeerToGravitePlacementMapTable:Dictionary<String,String>? = nil
    private var interstitialTable:Dictionary<String, InterstitialSet> = Dictionary()
    
    func loadInterstitial(config: GraviteInterstitialConfig) -> Void {
        
        self.interstitialDelegate = config.interstitialDelegate
        
        if let ylAdUnitData = config.ylAdUnitData {
            
            let placementName = getPlacementNameForGravite(ylAdUnitData: ylAdUnitData)
            
            if interstitialTable[placementName] == nil{
                if let interstitialAd = AATSDK.createFullscreenPlacement(name: placementName) {
                    // Set placement delegate to listen to the callbacks
                    interstitialAd.delegate = self
                    interstitialTable[placementName] = InterstitialSet(interstitialAd)
                    
                    // This will reload the interstitial, then interstitialAd.stopAutoReload() must be called.
                    // Otherwise, the ad will keep rendered.
                    interstitialAd.startAutoReload()
                    
                    // Manually, reload the ad. This will render the ad only once.
                    // interstitialAd.reload()
                }
                else {
                    SLogger.e("\(GraviteConstants.logTag) Failed to create an interstitial ad")
                    self.interstitialDelegate?.onAdFailedToLoad?(interstitial: nil, error: GraviteError.FailedToCreate)
                }
            }
        }
    }
    
    func setPlacementMapTable(stroeerToGravite:Dictionary<String,String>?)
    {
        stroeerToGravitePlacementMapTable = stroeerToGravite
    }
    
    func showInterstitial(ylAdUnitData: YLAdUnitData){
        let placementName = getPlacementNameForGravite(ylAdUnitData: ylAdUnitData)

        let placement = interstitialTable[placementName]
        
        if (placement != nil && placement!.interstitialAd.hasAd()) {
            
            placement!.interstitialAd.show()
            SLogger.i("\(GraviteConstants.logTag) Interstitial shown for ad unit: " + placementName);
        } else if (placement == nil) {
            SLogger.i("\(GraviteConstants.logTag) No interstitial found for ad unit: " + placementName);
        } else {
            SLogger.i("\(GraviteConstants.logTag) Interstitial not ready yet for ad unit: " + placementName);
        }
    }
    
    func isInterstitialAvailable(ylAdUnitData: YLAdUnitData) -> Bool {
        let placementName = getPlacementNameForGravite(ylAdUnitData: ylAdUnitData)
        let placement = interstitialTable[placementName];
        return placement != nil && placement!.interstitialAd.hasAd();
    }
    
    private func getPlacementNameForGravite(ylAdUnitData: YLAdUnitData) -> String {
        return GraviteHelper.convertAdslot(placementTable:stroeerToGravitePlacementMapTable, adSlot: ylAdUnitData.getPlacementName())
    }
}

public enum GraviteError : Error{
    case NoAds
    case NoReady
    case FailedToCreate
}

extension GraviteInterstitial: AATFullscreenPlacementDelegate {
    func aatPauseForAd(placement: AATKit.AATPlacement) {
        SLogger.i("\(GraviteConstants.logTag) interstitial is paused")
    }
    
    /**
        This function will be called when the interstitial is ready
     */
    func aatHaveAd(placement: AATPlacement) {
        SLogger.i("\(GraviteConstants.logTag) interstitial is available")
    }
    
    
    func aatNoAd(placement: AATPlacement) {
        SLogger.i("\(GraviteConstants.logTag) No interstitial is ready to render")
        self.interstitialDelegate?.onAdFailedToLoad?(interstitial: nil, error: GraviteError.NoReady)
    }
    
    func aatAdCurrentlyDisplayed(placement: AATPlacement) {
        SLogger.i("\(GraviteConstants.logTag) interstitial is currently displayed")
        // Ad has been displayed on the screen
    }
    
    func aatResumeAfterAd(placement: AATPlacement) {
        // Back to the app
        SLogger.i("\(GraviteConstants.logTag) interstitial is resumed after Ad")
    }
}
