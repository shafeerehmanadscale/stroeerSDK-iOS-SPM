import ConsentViewController
import UIKit

public protocol YLConsentManager {
    
    var messageLanguage: SPMessageLanguage { get set }
    
    func customConsentGDPR(vendors: [String], categories: [String], legIntCategories: [String], handler: @escaping (SPGDPRConsent) -> Void)
    
    func loadMessage(forAuthId authId: String?, publisherData: SPPublisherData?)
    
    func loadGDPRPrivacyManager(withId id: String, tab: ConsentViewController.SPPrivacyManagerTab, useGroupPmIfAvailable: Bool)
    
    static func clearAllData()
}

extension SPConsentManager: YLConsentManager {
    
}
