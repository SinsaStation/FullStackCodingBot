import Foundation
import GoogleMobileAds

protocol AdStorageType {
    
    func adToShow() -> GADRewardedAd?
    
    func availableAdCount() -> Int
    
    func adDidFinished()
    
    func setup(count: Int)
    
}
