import Foundation
import GoogleMobileAds

class AdStorage: AdStorageType {
    
    private var ads = [GADRewardedAd]()
    
    func adToShow() -> GADRewardedAd? {
        return ads.last
    }
    
    func availableAdCount() -> Int {
        return ads.count
    }
    
    func adDidFinished() {
        ads.removeLast()
        print("남은 광고:", ads.count, "개")
    }
    
    // 시간 로직 필요
    func setup(count: Int) {
        (1...count).forEach { _ in
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
    
}
