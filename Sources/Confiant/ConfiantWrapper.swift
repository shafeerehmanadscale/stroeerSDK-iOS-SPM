//
//  ConfiantWrapper.swift
//  ConfiantPlugin
//
//  Created by Hyungon Kim on 10/10/2024.
//

import Foundation
import UIKit
import ConfiantSDK
import YieldloveAdIntegration

/// A wrapper class for integrating the Confiant SDK with the Yieldlove Ad Integration.
/// This class provides methods for initializing, enabling test and reload modes, and marking ad slots for monitoring.
@objcMembers public class ConfiantWrapper: NSObject, IAdMonitoring {
    
    // MARK: - Properties

    /// Log tag for debugging output.
    private let tag: String = "[ConfiantPlugin]"

    /// Instance of the Confiant SDK.
    private var confiantInstance: Confiant?

    /// Flag indicating whether test mode is enabled.
    private var testMode: Bool = false

    /// Flag indicating whether monitoring has started.
    private var isMonitorStarted = false

    /// Flag indicating whether reload mode is enabled.
    private var reloadMode: Bool = false

    // MARK: - Public Methods

    /// Enables reload functionality for the Confiant SDK.
    /// Must be called before starting monitoring.
    public func enableReload() {
        if isMonitorStarted {
            SLogger.e("\(tag) Monitoring is already started. enableReload should be called before starting monitoring.")
            return
        }
        SLogger.i("\(tag) Reload Mode is enabled. Confiant SDK will reload the ad slot if a detection event is detected.")
        reloadMode = true
    }

    /// Enables test mode for the Confiant SDK.
    /// Must be called before initialization.
    public func enableTestMode() {
        if confiantInstance != nil {
            SLogger.e("\(tag) Settings are already initialized. enableTestMode should be called before initialization.")
            return
        }

        SLogger.i("\(tag) Test Mode is enabled. Confiant SDK will block all ads in this mode.")
        testMode = true
    }

    /// Initializes the Confiant SDK.
    /// - Parameters:
    ///   - confiantPropertyId: The property ID for the Confiant SDK.
    ///   - enableReload: Flag indicating whether reload mode should be enabled.
    ///   - completetion: Closure called with the success status of the initialization.
    public func initialize(confiantPropertyId: String, completetion: @escaping (Bool) -> Void) {
        var observeMode: ConfiantSDK.DetectionObserving.Mode? = nil

        if reloadMode {
            observeMode = .withSlotMatching(
                { [weak self] webView, detectionObservingEvent in
                    guard let self = self else {
                        SLogger.e("The parent instance is disposed.")
                        return
                    }
                    if let detectionReport = detectionObservingEvent.detectionReport {
                        
                        
                        if detectionReport.isBlocked {
                            if let placementId = detectionObservingEvent.placementId, placementId.count > 0 {
                                SLogger.i(
                                    "\(self.tag) RELOAD Rule \(detectionReport.blockingId) detected suspicious content " +
                                    "from \(detectionReport.impressionData.provider); " +
                                    "\(placementId) was blocked: \(detectionReport.isBlocked)"
                                )
                                AdMonitorRefresher.shared.reload(slotView: webView, placementId: placementId)
                            }
                        }
                    }
                }
            )
        } else {
            observeMode = .withoutSlotMatching(
                { [weak self] webView, detectionObservingEvent in
                    guard let self = self else {
                        SLogger.d("The parent instance is disposed.")
                        return
                    }

                    if let detectionReport = detectionObservingEvent.detectionReport {
                        SLogger.i("\(self.tag) Rule \(detectionReport.blockingId) detected suspicious content from \(detectionReport.impressionData.provider) was blocked: \(detectionReport.isBlocked)")
                    }
                }
            )
        }

        let settingsResult = Settings.with(
            propertyId: confiantPropertyId,
            enableRate: .none, enableHTTPCache: false,
            adReporterMode: .none,
            detectionObservingMode: observeMode,
            forceBlockOnLoad: .some(self.testMode))

        switch settingsResult {
        case .success(let settings):
            SLogger.i("\(tag) Confiant Settings created successfully.")

            Confiant.initialize(settings: settings) { [weak self] result in
                guard let self = self else {
                    SLogger.e("The ConfiantWrapper instance is disposed.")
                    completetion(false)
                    return
                }

                switch result {
                case .success(let confiantSingleton):
                    SLogger.i("\(tag) Successfully initialized Confiant SDK")
                    self.confiantInstance = confiantSingleton
                    self.isMonitorStarted = true
                    completetion(true)
                case .failure(let initError):
                    SLogger.e("\(tag) Failed to initialize Confiant SDK : \(initError.localizedDescription) \(initError.errorCode)", initError)
                    completetion(false)
                }
            }

        case .failure(let settingsError):
            SLogger.e("\(tag) Failed to create Confiant Settings: \(settingsError.localizedDescription) \(settingsError.errorCode)", settingsError)
            completetion(false)
        }
    }

    /// Marks a slot view for ad monitoring.
    /// - Parameters:
    ///   - slotView: The `UIView` to be monitored.
    ///   - placementId: The placement ID associated with the ad.
    public func mark(slotView: UIView, withPlacementId placementId: String) {
        if isMonitorStarted, let confiantInstance = confiantInstance {
            confiantInstance.mark(.slotView(slotView: slotView), withPlacementId: placementId)
        } else {
            SLogger.e("\(tag) Confiant SDK is not initialized. Cannot mark the view.")
        }
    }
}
