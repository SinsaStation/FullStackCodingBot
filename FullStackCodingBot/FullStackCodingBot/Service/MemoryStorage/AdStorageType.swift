import Foundation
import RxSwift
import GoogleMobileAds

protocol AdStorageType {
    
    func setup()
    
    func adToShow() -> GADRewardedAd?
    
    func availableItems() -> Observable<[ShopItem]>
    
    func adDidFinished(with successStatus: Bool)

}
