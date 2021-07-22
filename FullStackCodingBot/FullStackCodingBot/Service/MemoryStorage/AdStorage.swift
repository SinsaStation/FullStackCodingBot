import Foundation
import RxSwift
import GoogleMobileAds

final class AdStorage: AdStorageType {
    
    private var giftCount = 0
    private var ads = [GADRewardedAd]()
    
    private lazy var itemStorage = BehaviorSubject(value: items())
    
    private func items() -> [ShopItem] {
        return ads.map { ShopItem.adMob($0) } + (0..<giftCount).map { _ in ShopItem.gift }
    }
    
    // 시간 로직 필요 & 저장된 광고가 있다면 우선 불러오기
    func setup() {
        setAds()
        setGifts()
    }
    
    private func setAds() {
        (1...ShopSetting.adForADay).forEach { _ in
            let request = GADRequest()
            
            GADRewardedAd.load(withAdUnitID: IdentiferAD.test, request: request) { [unowned self] ads, error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    guard let newAd = ads else { return }
                    self.ads.append(newAd)
                    self.itemStorage.onNext(self.items())
                }
            }
        }
    }
    
    private func setGifts() {
        giftCount = ShopSetting.freeReward
    }
    
    func availableItems() -> Observable<[ShopItem]> {
        return itemStorage
    }
    
    func adDidFinished(_ finishedAd: GADRewardedAd) {
        ads.enumerated().forEach { index, targetAd in
            if targetAd == finishedAd {
                ads.remove(at: index)
            }
        }
        itemStorage.onNext(items())
    }
    
    func giftTaken() {
        giftCount -= 1
        itemStorage.onNext(items())
    }
    
}
