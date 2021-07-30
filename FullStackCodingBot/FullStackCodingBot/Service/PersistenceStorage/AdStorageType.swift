import Foundation
import RxSwift
import GoogleMobileAds

protocol AdStorageType {
    
    @discardableResult
    func setNewRewardsIfPossible() -> Bool
    
    func update(with newInfo: AdsInformation)
    
    func availableItems() -> Observable<[ShopItem]>
    
    func adDidFinished(_ finishedAd: GADRewardedAd)
    
    func giftTaken()
    
    func currentInformation() -> AdsInformation

}
