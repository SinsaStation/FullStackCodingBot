import Foundation
import RxSwift
import GoogleMobileAds

final class AdStorage: AdStorageType {

    private var lastUpdate: Date
    private var giftStatus: ShopItem
    private var ads: [ShopItem]
    private lazy var itemStorage = BehaviorSubject(value: items())
    
    init(lastUpdate: Date = Date(timeIntervalSince1970: 0),
         giftStatus: ShopItem = .taken,
         ads: [ShopItem] = Array(repeating: .taken, count: ShopSetting.adForADay)) {
        self.lastUpdate = lastUpdate
        self.giftStatus = giftStatus
        self.ads = ads
    }
    
    func setNewRewardsIfPossible(with newInfo: AdsInformation?) -> Bool {
        let currentInfo = newInfo ?? currentInformation()
        lastUpdate = currentInfo.lastUpdated
        
        guard isUpdatable() else {
            setRewards(from: currentInfo)
            return false
        }
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
    
    private func setRewards(from currentInfo: AdsInformation) {
        let currentAdStates = currentInfo.ads
        setAds(with: currentAdStates)
        
        let currentGiftState: ShopItem = currentInfo.gift != nil ? .gift : .taken
        setGifts(with: currentGiftState)
    }
    
    private func setAds(with adStates: [Bool] = Array(repeating: true, count: ShopSetting.adForADay)) {
        adStates.enumerated().forEach { index, isAvailable in
            if isAvailable {
                downloadAd(to: index)
                self.ads[index] = ShopItem.loading
            } else {
                self.ads[index] = ShopItem.taken
            }
        }
        publishCurrentItems()
    }
    
    private func downloadAd(to index: Int) {
        let request = GADRequest()
        
        GADRewardedAd.load(withAdUnitID: IdentiferAD.test, request: request) { [unowned self] ads, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            guard let newAd = ads else { return }
            self.ads[index] = ShopItem.adMob(newAd)
            self.publishCurrentItems()
        }
    }
    
    private func publishCurrentItems() {
        itemStorage.onNext(items())
    }
    
    private func setGifts(with giftState: ShopItem = .gift) {
        self.giftStatus = giftState
        publishCurrentItems()
    }
    
    private func items() -> [ShopItem] {
        return ads + [giftStatus]
    }
    
    func availableItems() -> Observable<[ShopItem]> {
        return itemStorage
    }
    
    func adDidFinished(_ finishedAd: GADRewardedAd) {
        ads.enumerated().forEach { index, targetAd in
            switch targetAd {
            case .adMob(let targetAd):
                if targetAd == finishedAd {
                    ads[index] = .taken
                }
            default:
                return
            }
        }
        publishCurrentItems()
    }
    
    func giftTaken() {
        giftStatus = .taken
        publishCurrentItems()
    }
    
    func currentInformation() -> AdsInformation {
        let ads = adsToStatus()
        let gift = giftToStatus()
        let result = AdsInformation(ads: ads, lastUpdated: lastUpdate, gift: gift)
        return result
    }
        
    private func adsToStatus() -> [Bool] {
        return ads.map { status in
            switch status {
            case .taken:
                return false
            default:
                return true
            }
        }
    }
    
    private func giftToStatus() -> Int? {
        switch giftStatus {
        case .gift:
            return 0
        default:
            return nil
        }
    }
}
