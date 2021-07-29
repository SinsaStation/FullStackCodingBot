import Foundation
import RxSwift
import GoogleMobileAds

protocol AdStorageType {
    
    @discardableResult
    func updateIfPossible() -> Bool
    
    func availableItems() -> Observable<[ShopItem]>
    
    func adDidFinished(_ finishedAd: GADRewardedAd)
    
    func giftTaken(_ takenGift: Int)
    
    func adsInformation() -> AdsInformation
    
    func updateAdsInformation(_ info: AdsInformation)
}
