import Foundation
import RxSwift
import GoogleMobileAds

final class AdStorage: AdStorageType {
    
    private var gifts: [Int?] = Array(repeating: nil, count: ShopSetting.freeReward)
    private var ads: [GADRewardedAd?] = Array(repeating: nil, count: ShopSetting.adForADay)
    private lazy var itemStorage = BehaviorSubject(value: items())
    
    private func items() -> [ShopItem] {
        let adItems = ads.map { $0 != nil ? ShopItem.adMob($0!) : ShopItem.taken }
        let giftItems = gifts.map { $0 != nil ? ShopItem.gift($0!) : ShopItem.taken }
        return adItems + giftItems
    }
    
    func setup() {
        setAds()
        setGifts()
    }
    
    private func setAds() {
        (0..<ShopSetting.adForADay).forEach { index in
            let request = GADRequest()
            
            GADRewardedAd.load(withAdUnitID: IdentiferAD.test, request: request) { [unowned self] ads, error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    guard let newAd = ads else { return }
                    self.ads[index] = newAd
                    self.itemStorage.onNext(self.items())
                }
            }
        }
    }
    
    private func setGifts() {
        gifts = (0..<ShopSetting.freeReward).map { $0 }
    }
    
    func availableItems() -> Observable<[ShopItem]> {
        return itemStorage
    }
    
    func adDidFinished(_ finishedAd: GADRewardedAd) {
        ads.enumerated().forEach { index, targetAd in
            if targetAd == finishedAd {
                ads[index] = nil
            }
        }
        itemStorage.onNext(items())
    }
    
    func giftTaken(_ takenGift: Int) {
        gifts[takenGift] = nil
        itemStorage.onNext(items())
    }
    
}
