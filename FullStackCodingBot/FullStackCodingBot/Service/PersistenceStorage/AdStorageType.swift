import Foundation
import RxSwift
import GoogleMobileAds

protocol AdStorageType {
    
    @discardableResult
    func setup() -> Bool
    
    func availableItems() -> Observable<[ShopItem]>
    
    func adDidFinished(_ finishedAd: GADRewardedAd)
    
    func giftTaken(_ takenGift: Int)
    
    func adsInformation() -> AdsInformation
}
