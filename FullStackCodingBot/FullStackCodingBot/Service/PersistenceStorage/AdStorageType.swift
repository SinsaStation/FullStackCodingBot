import Foundation
import RxSwift
import GoogleMobileAds

protocol AdStorageType {
    
    @discardableResult
    func updateIfPossible() -> Bool
    
    func updateAdsInformation(_ info: AdsInformation)
    
    func availableItems() -> Observable<[ShopItem]>
    
    func adDidFinished(_ finishedAd: GADRewardedAd)
    
    func giftTaken(_ takenGift: Int)
    
    func adsInformation() -> AdsInformation

}
