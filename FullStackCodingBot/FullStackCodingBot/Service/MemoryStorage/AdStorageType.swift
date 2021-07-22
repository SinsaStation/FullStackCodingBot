import Foundation
import RxSwift
import GoogleMobileAds

protocol AdStorageType {
    
    func setup()
    
    func availableItems() -> Observable<[ShopItem]>
    
    func adDidFinished(_ finishedAd: GADRewardedAd)
    
    func giftTaken(_ takenGift: Int)

}
