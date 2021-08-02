import Foundation
import RxSwift
import GoogleMobileAds

class MockAdStorage: AdStorageType {

    private var lastUpdated: Date
    private var ads: [GADRewardedAd?]
    private var giftStatus: Bool
    private let calendar = Calendar.current
    private let today = Date()

    init(with adInformation: AdsInformation) {
        self.lastUpdated = adInformation.lastUpdated
        self.ads = adInformation.ads.map { $0 ? GADRewardedAd() : nil }
        self.giftStatus = adInformation.gift != nil
    }
    
    func setNewRewardsIfPossible(with newInfo: AdsInformation?) -> Bool {
        let lastUpdated = newInfo?.lastUpdated ?? self.lastUpdated
        let isAlreadyUpdated = calendar.isDate(today, inSameDayAs: lastUpdated)
        let isTimeToSetNew = !isAlreadyUpdated
        
        if isTimeToSetNew {
            setNewRewards()
        }
        return isTimeToSetNew
    }
    
    private func setNewRewards() {
        ads = Array(repeating: GADRewardedAd(), count: 3)
        giftStatus = true
    }
    
    func availableItems() -> Observable<[ShopItem]> {
        let ads = ads.map { $0 != nil ? ShopItem.adMob($0!) : ShopItem.taken }
        let gift = giftStatus ? ShopItem.gift : ShopItem.taken
        return BehaviorSubject(value: ads + [gift])
    }
    
    func adDidFinished(_ finishedAd: GADRewardedAd) {
        ads.enumerated().forEach { index, targetAd in
            if finishedAd == targetAd {
                ads[index] = nil
            }
        }
    }
    
    func giftTaken() {
        giftStatus = false
    }
    
    func currentInformation() -> AdsInformation {
        let adsStatus = self.ads.map { $0 != nil }
        let gift = giftStatus ? 0 : nil
        return AdsInformation(ads: adsStatus, lastUpdated: self.lastUpdated, gift: gift)
    }
}
