# AATKit

## Introduction

Integrate many different advertising networks by adding this mediation
framework only once.

## Resources

You can find detailed information about this SDK in the
[AATKit Wiki](https://bitbucket.org/addapptr/aatkit-ios/wiki/Documentation).
We recommend you take a look at these pages to integrate AATKit:

* [Initializing AATKit](https://aatkit.gitbook.io/ios-integration/start/initialization)
* [Integrating Banner Ads](https://aatkit.gitbook.io/ios-integration/formats/banner)
* [Integrating Fullscreen Ads](https://aatkit.gitbook.io/ios-integration/formats/fullscreen-interstitial)
* [Integrating AppOpen Ads](https://aatkit.gitbook.io/ios-integration/formats/appopen-google)
* [Integrating Rewarded Video Ads](https://aatkit.gitbook.io/ios-integration/formats/rewarded-video)
* [Integrating Native Ads](https://aatkit.gitbook.io/ios-integration/formats/native-ad)

You can find the API reference online on [Reference](https://aatkit.gitbook.io/ios-integration/other/reference).

## Installation with CocoaPods

AATKit is available as a CocoaPod at [https://cocoapods.org/pods/AATKit](https://cocoapods.org/pods/AATKit)

    pod 'AATKit'

### Subspecs

In order to ease the integration of AATKit, this will install every
supported ad network. 

Using the aforementioned line is equivalent to this:

    pod 'AATKit/Core'
    pod 'AATKit/Admob'
    pod 'AATKit/AdX'
    pod 'AATKit/AppLovin'
    pod 'AATKit/AppLovinMax'
    pod 'AATKit/AppNexus'
    pod 'AATKit/CriteoSDK'
    pod 'AATKit/DFP'
    pod 'AATKit/Facebook'
    pod 'AATKit/FeedAd'
    pod 'AATKit/Inmobi'
    pod 'AATKit/OguryAds'
    pod 'AATKit/PubNative'
    pod 'AATKit/Prebid'
    pod 'AATKit/Smaato'
    pod 'AATKit/SmartAdServer'
    pod 'AATKit/Unity'
    pod 'AATKit/Vungle'
    pod 'AATKit/YOC'
    pod 'AATKit/IronSource'



### Remarks
AATKit targets iOS 10 and above, CocoaPods bristles against using some sub-specs
that reference versions of ad network SDKs that require a higher minimum deployment target
than iOS 10. Due to this conflicts, the AATKit available via CocoaPods is missing some sub-specs.

You can still use these ad network SDK though, by specifying the dependency yourself. The AATKit will
pick up the SDKs at runtime, so no further configuration is necessary.
