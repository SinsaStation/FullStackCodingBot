import UIKit
import GoogleMobileAds

final class ShopViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: ShopViewModel!
    private var rewardedAd = [GADRewardedAd]()
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var moveToAdsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func bindViewModel() {
        moveToAdsButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                guard let adToShow = rewardedAd.first else { return }
                self.load(adToShow)
            }).disposed(by: rx.disposeBag)
        
        cancelButton.rx.action = viewModel.cancelAction
    }
}

// MARK: Setup
private extension ShopViewController {
    private func setup() {
        setupGoogleAds(count: ShopSetting.adForADay)
    }

    private func setupGoogleAds(count: Int) {
        (1...count).forEach { _ in
            let request = GADRequest()
            
            GADRewardedAd.load(withAdUnitID: IdentiferAD.test, request: request) { ads, error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    guard let newAd = ads else { return }
                    newAd.fullScreenContentDelegate = self
                    self.rewardedAd.append(newAd)
                }
            }
        }
    }
    
    private func load(_ gooleAd: GADRewardedAd) {
        gooleAd.present(fromRootViewController: self) {
            print("Get Money")
        }
    }
}

// MARK: Google Ads
extension ShopViewController: GADFullScreenContentDelegate {
    // swiftlint:disable:next identifier_name
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("ad 실패")
        print("남은 광고 개수:", self.rewardedAd.count)
        // 하나 더 만들기
        setupGoogleAds(count: 1)
    }
    
    // swiftlint:disable:next identifier_name
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        DispatchQueue.main.async {
            self.rewardedAd.remove(at: 0)
            print("남은 광고 개수:", self.rewardedAd.count)
        }
    }
}
