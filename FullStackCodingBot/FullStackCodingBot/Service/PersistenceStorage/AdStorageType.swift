import Foundation
import RxSwift
import GoogleMobileAds

protocol AdStorageType {
    
    @discardableResult
    func setNewRewardsIfPossible(with newInfo: AdsInformation?) -> Observable<Bool>
    
    func availableItems() -> Observable<[ShopItem]>
    
    func adDidFinished(_ finishedAd: GADRewardedAd)
    
    func giftTaken()
    
    func currentInformation() -> AdsInformation

}
