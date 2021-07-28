import Foundation
import RxSwift
import GoogleMobileAds

final class AdStorage: AdStorageType {
    
    private var lastUpdate: Date
    private var gifts: [Int?]
    private var ads: [GADRewardedAd?]
    private lazy var itemStorage = BehaviorSubject(value: items())
    
    init(lastUpdate: Date = Date(timeIntervalSince1970: 0),
         gifts: [Int?] = Array(repeating: nil, count: ShopSetting.freeReward),
         ads: [GADRewardedAd?] = Array(repeating: nil, count: ShopSetting.adForADay)) {
        self.lastUpdate = lastUpdate
        self.gifts = gifts
        self.ads = ads
    }
    
    private func items() -> [ShopItem] {
        let adItems = ads.map { $0 != nil ? ShopItem.adMob($0!) : ShopItem.taken }
        let giftItems = gifts.map { $0 != nil ? ShopItem.gift($0!) : ShopItem.taken }
        return adItems + giftItems
    }
    
    func setup() -> Bool {
        if isUpdatable() {
            setAds()
            setGifts()
            return true
        } else {
            return false
        }
    }
    
    private func isUpdatable() -> Bool {
        let today = Date()
        let isUpdated = Calendar.current.isDate(today, inSameDayAs: lastUpdate)
        lastUpdate = today
        return !isUpdated
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
    
    func adsInformation() -> AdsInformation {
        let ads = ads.map { $0 != nil }
        let result = AdsInformation(ads: ads, lastUpdated: lastUpdate, gift: gifts.first ?? nil)
        return result
    }
}
