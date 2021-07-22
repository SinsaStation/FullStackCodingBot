import Foundation
import GoogleMobileAds

protocol AdStorageType {
    
    func setup()
    
    func adToShow() -> GADRewardedAd?
    
    func availableItems() -> [ShopItem]
    
    func adDidFinished(with successStatus: Bool)

}
