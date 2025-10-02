import ConsentViewController
import PromiseKit
import YieldloveAdIntegration
import UIKit

protocol ConsentManagerFactory {
    func make(configurationManager: IConfigurationManager, delegate: YLConsentDelegate, variant: String?) -> Promise<YLConsentManager>
}

public class YLConsentManagerFactory: ConsentManagerFactory {
    
    var shouldUseStagingConfiguration: Bool {
        return ProcessInfo.processInfo.environment["STAGINGCONFIGURATION"] == "1"
    }
    
    var campaignEnv: SPCampaignEnv {
        return self.shouldUseStagingConfiguration ? .Stage : .Public
    }
    
    var campaigns: SPCampaigns {
        return SPCampaigns(
            gdpr: SPCampaign(),
            environment: campaignEnv
        )
    }

    func make(configurationManager: IConfigurationManager,
              delegate: YLConsentDelegate,
              variant: String? = nil) -> Promise<YLConsentManager> {
        getConsentData(configurationManager: configurationManager, variant: variant)
            .then { (consentData: ConsentData) -> Promise<YLConsentManager> in
                self.getSPConsentManager(consentData, delegate)
            }
    }
    
    private func getConsentData(configurationManager: IConfigurationManager, variant: String? = nil) -> Promise<ConsentData> {
        return configurationManager.getConsentData(overrideProperties: variant)
            .map { (consentData: ConfigurableConsentData) -> ConsentData in
                return ConsentData(
                    accountId: consentData.accountId,
                    isActive: consentData.isActive,
                    propertyId: consentData.propertyId,
                    propertyName: consentData.propertyName,
                    privacyManagerId: consentData.privacyManagerId
                )
            }
    }

    private func getSPConsentManager(_ consentData: ConsentData, _ delegate: SPDelegate) -> Promise<YLConsentManager> {
        return Promise { seal in
            do {
                let consentManager = try buildSPConsentManager(consentData, delegate)
                seal.resolve(consentManager, nil)
            } catch {
                seal.reject(error)
            }
        }
    }
    
    private func buildSPConsentManager(_ consentData: ConsentData, _ delegate: SPDelegate) throws -> YLConsentManager {
        guard consentData.isActive else {
            throw YLConsentManagerFactoryError.consentExternalConfigurationIsNotActive
        }
        guard let accountId = Int(consentData.accountId) else {
            throw YLConsentManagerFactoryError.consentConfigurationIncorrect
        }
        return SPConsentManager(
            accountId: accountId,
            propertyId: consentData.propertyId,
            propertyName: try SPPropertyName(consentData.propertyName),
            campaigns: campaigns,
            delegate: delegate
        )
    }

}
