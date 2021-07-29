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
    
    func updateIfPossible() -> Bool {
        guard isUpdatable() else { return false }
        setAds()
        setGifts()
        return true
    }
    
    private func isUpdatable() -> Bool {
        let today = Date()
        let isUpdated = Calendar.current.isDate(today, inSameDayAs: lastUpdate)
        lastUpdate = today
        return !isUpdated
    }
    
    func updateAdsInformation(_ info: AdsInformation) {
        lastUpdate = info.lastUpdated
        guard !updateIfPossible() else { return }
        showCurrentRewards(from: info)
    }
    
    private func showCurrentRewards(from currentInfo: AdsInformation) {
        let currentAdStates = currentInfo.ads
        setAds(with: currentAdStates)
        
        let currentGiftState = currentInfo.gift
        setGifts(with: currentGiftState)
    }
    
    private func setAds(with adStates: [Bool] = Array(repeating: true, count: ShopSetting.adForADay)) {
        adStates.enumerated().forEach { index, isAvailable in
            if isAvailable {
                downloadAd(to: index)
            } else {
                self.ads[index] = nil
            }
        }
    }
    
    private func downloadAd(to index: Int) {
        let request = GADRequest()
        
        GADRewardedAd.load(withAdUnitID: IdentiferAD.test, request: request) { [unowned self] ads, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            guard let newAd = ads else { return }
            self.ads[index] = newAd
            self.publishCurrentItems()
        }
    }
    
    private func publishCurrentItems() {
        itemStorage.onNext(items())
    }
    
    private func setGifts(with giftState: Int? = ShopSetting.freeReward) {
        gifts = [giftState]
        publishCurrentItems()
    }
    
    private func items() -> [ShopItem] {
        let adItems = ads.map { $0 != nil ? ShopItem.adMob($0!) : ShopItem.taken }
        let giftItems = gifts.map { $0 != nil ? ShopItem.gift($0!) : ShopItem.taken }
        return adItems + giftItems
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
        publishCurrentItems()
    }
    
    func giftTaken(_ takenGift: Int) {
        gifts[takenGift] = nil
        publishCurrentItems()
    }
    
    func adsInformation() -> AdsInformation {
        let ads = ads.map { $0 != nil }
        let result = AdsInformation(ads: ads, lastUpdated: lastUpdate, gift: gifts.first ?? nil)
        return result
    }
}
