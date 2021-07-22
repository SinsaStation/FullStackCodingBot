import Foundation
import RxSwift
import GoogleMobileAds

final class AdStorage: AdStorageType {
    
    private var giftCount = 0
    private var ads = [GADRewardedAd]()
    
    // 시간 로직 필요 & 저장된 광고가 있다면 우선 불러오기
    func setup() {
        setAds()
        setGifts()
    }
    
    private func setAds() {
        (1...ShopSetting.adForADay).forEach { _ in
            let request = GADRequest()
            
            GADRewardedAd.load(withAdUnitID: IdentiferAD.test, request: request) { ads, error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    guard let newAd = ads else { return }
                    self.ads.append(newAd)
                    print("광고 개수:", self.ads.count, "개")
                }
            }
        }
    }
    
    private func setGifts() {
        giftCount = ShopSetting.freeReward
    }
    
    func adToShow() -> GADRewardedAd? {
        return ads.last
    }
    
    func availableItems() -> Observable<[ShopItem]> {
        let items = ads.map { ShopItem.adMob($0) } + (0..<giftCount).map { _ in ShopItem.gift }
        return BehaviorSubject(value: items)
    }
    
    func adDidFinished(with successStatus: Bool) {
        ads.removeLast()
        print("남은 광고:", ads.count, "개")
    }
    
}
