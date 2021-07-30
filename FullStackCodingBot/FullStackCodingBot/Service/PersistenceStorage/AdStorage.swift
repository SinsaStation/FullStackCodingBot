import Foundation
import RxSwift
import GoogleMobileAds

enum GiftStatus {
    case available
    case taken
}

final class AdStorage: AdStorageType {

    private var lastUpdate: Date
    private var giftStatus: GiftStatus
    private var ads: [GADRewardedAd?]
    private lazy var itemStorage = BehaviorSubject(value: items())
    
    init(lastUpdate: Date = Date(timeIntervalSince1970: 0),
         giftStatus: GiftStatus = .taken,
         ads: [GADRewardedAd?] = Array(repeating: nil, count: ShopSetting.adForADay)) {
        self.lastUpdate = lastUpdate
        self.giftStatus = giftStatus
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
        
        let currentGiftState: GiftStatus = currentInfo.gift != nil ? .available : .taken
        setGifts(with: currentGiftState)
    }
    
    private func setAds(with adStates: [Bool] = Array(repeating: true, count: ShopSetting.adForADay)) {
        adStates.enumerated().forEach { index, isAvailable in
            if isAvailable {
                downloadAd(to: index)
            } else {
                self.ads[index] = nil
                publishCurrentItems()
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
    
    private func setGifts(with giftState: GiftStatus = .available) {
        self.giftStatus = giftState
        publishCurrentItems()
    }
    
    private func items() -> [ShopItem] {
        let adItems = ads.map { $0 != nil ? ShopItem.adMob($0!) : ShopItem.taken }
        let giftItem = giftStatus == .available ? ShopItem.gift : ShopItem.taken
        return adItems + [giftItem]
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
    
    func giftTaken() {
        giftStatus = .taken
        publishCurrentItems()
    }
    
    func adsInformation() -> AdsInformation {
        let ads = ads.map { $0 != nil }
        let result = AdsInformation(ads: ads, lastUpdated: lastUpdate, gift: giftStatus == .available ? 0 : nil)
        return result
    }
}
