//
//  GraviteWrapper.swift
//  GravitePlugin
//
//  Created by Hyungon Kim on 18/11/2024.
//

import Foundation
import AATKit
import YieldloveAdIntegration
import UIKit

@objc(YLGraviteWrapper)   
@objcMembers public class GraviteWrapper: NSObject, IBackFill {
    
    
    private var graviteInstance: IBackFill?
    
    private var testMode: Bool = false
    private var testBundleId: String? = nil
    private var testAccountId: Int? = nil
    
    private var isGraviteStarted: Bool = false
    
    private var debugMode: Bool = false
    
    private var bannerLoader: GraviteBanner = GraviteBanner()
    
    private var interstitialLoader: GraviteInterstitial = GraviteInterstitial()
    
    private var cacheSize: Int = 1
    
    public func enableTestMode(bundleId: String? = nil, accountId: Int? = nil, forceToExecute: Bool = false) {
        
        if isGraviteStarted {
            SLogger.e("\(GraviteConstants.logTag) Gravite is already started. testMode should be set before initializing Gravite")
            return
        }
        SLogger.i("\(GraviteConstants.logTag) Test mode enabled")
        testBundleId = bundleId
        testAccountId = accountId
        testMode = true
    }
    
    public func enableDebugMode() {
        if isGraviteStarted {
            SLogger.e("\(GraviteConstants.logTag) Gravite is already started. debugMode should be set before initializing Gravite")
            return
        }
        
        SLogger.i("\(GraviteConstants.logTag) Debug mode enabled")
        debugMode = true
    }
    
    public func initialize() {
        let graviteConfig = AATConfiguration()
        
        // Default setting is info. By calling enableDebug will change this log level
        if debugMode {
            AATSDK.setLogLevel(logLevel: .debug)
        }
        else {
            AATSDK.setLogLevel(logLevel: .info)
        }
        
        graviteConfig.delegate = self
        
        if (testMode)
        {
            if let testAccountId = testAccountId {
                graviteConfig.testModeAccountId = NSNumber(value:testAccountId)
            }
            
            if let testBundleId = testBundleId {
                graviteConfig.alternativeBundleId = testBundleId
            }
        }
        
        let vendorConsent = AATVendorConsent(delegate: self)
        graviteConfig.consent = vendorConsent
        
        AATSDK.initAATKit(with: graviteConfig)
        
        // Set reporting
        AATSDK.setReportsDelegate(GraviteReportDelegate())
        
        // Disable Shake debugmode
        if !ConfigurationManager.isInspectionMode(){
            AATSDK.disableDebugScreen()
            SLogger.i("\(GraviteConstants.logTag) Shake debug mode is disabled ")
        }
        else{
            SLogger.i("\(GraviteConstants.logTag) Shake debug mode is enabled ")
        }
        
        isGraviteStarted = true
        
        SLogger.i("\(GraviteConstants.logTag) Gravite is initialized")
    }
    
    public func viewDidAppear(viewUIController: UIViewController)
    {
        print("[Shafee - Gravite] view did appear [END]")
        if isGraviteStarted {
            print("[Shafee - Gravite] view did appear IN \(viewUIController.description) [END]")
            AATSDK.controllerViewDidAppear(controller: viewUIController)
        }
    }
    
    public func viewWillDisappear() {
        print("[Shafee - Gravite] view did DISappear [END]")
        if isGraviteStarted {
            print("[Shafee - Gravite] view did DISappear IN [END]")
            AATSDK.controllerViewWillDisappear()
        }
    }
    
    public func getBannerLoader() -> (any YieldloveAdIntegration.IBackFillBanner)? {
        return bannerLoader
    }
    
    public func getInterstitialLoader() -> (any YieldloveAdIntegration.IBackFillInterstitial)? {
        return interstitialLoader
    }
    
    public func setCustomTargeting(targets: [String : [String]]) {
        if isGraviteStarted {
            AATSDK.setTargetingInfo(info: targets)
        }
    }
    
    public func getVersion() -> String {
        return AATSDK.getVersion()
    }
    
    public func getDebugInfo() -> IDebugInfo {
        return GraviteDebugInfo(sourceInfo: getAdsourceInfo())
    }
    
    public func getAdsourceInfo() -> AdSourceInfo {
        return AdSourceInfo(adSource: .Gravite, version: getVersion())
    }
    
    
    public func setCacheSize(size: Int) {
        cacheSize = size
        bannerLoader.setCacheSize(cacheSize: cacheSize)
    }
    
    public func setPlacementMapTable(stroeerToGravite: Dictionary<String, String>) {
        bannerLoader.setPlacementMapTable(stroeerToGravite: stroeerToGravite)
        interstitialLoader.setPlacementMapTable(stroeerToGravite: stroeerToGravite)
    }
    
    public func enableInspectionMode(){
        if isGraviteStarted {
            AATSDK.enableDebugScreen()
            SLogger.i("\(GraviteConstants.logTag) Shake debug mode is enabled ")
        }
    }
}

extension GraviteWrapper: AATManagedConsentDelegate {
    public func managedConsentNeedsUserInterface(_ managedConsent: AATManagedConsent) {
        // CMP is loaded and ready to be shown
        // Show the CMP using the root view controller
        SLogger.i("\(GraviteConstants.logTag) CMP needs user interface")
    }

    public func managedConsentCMPFinished(with state: AATManagedConsentState) {
      // The user finished his action with CMP with the state as the user chosen state
        SLogger.i("\(GraviteConstants.logTag) CMP finished with state: \(state)")
    }

    public func managedConsentCMPFailedToLoad(_ managedConsent: AATManagedConsent, with error: String) {
        // CMP failed to load with the error message.
        // Reload the CMP using the root view controller
        SLogger.i("\(GraviteConstants.logTag) CMP failed to load with error: \(error)")
        
    }

    public func managedConsentCMPFailedToShow(_ managedConsent: AATManagedConsent, with error: String) {
        // CMP failed to show with the error message
        SLogger.i("\(GraviteConstants.logTag) CMP failed to show with error: \(error)")
    }
}

extension GraviteWrapper: AATDelegate {
    public func AATKitObtainedAdRules(fromTheServer: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name("aatKitObtainedAdRules"), object: nil)
    }
}

extension GraviteWrapper: AATVendorConsentDelegate {
    public func getConsentForNetwork(_ network: AATKit.AATAdNetwork) -> AATKit.NonIABConsent {
        return GraviteConsentDecoder.isVendorConsentGiven(adNetwork: network)
    }
    
    public func getConsentForAddapptr() -> AATKit.NonIABConsent {
        return .obtained
    }
}


class GraviteReportDelegate : AATReportsDelegate {
    func onReportSent(_ report: String) {
        SLogger.i("\(GraviteConstants.logTag) \(#function) -> \(report)")
    }
}
