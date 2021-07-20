import UIKit
import GoogleMobileAds
final class ShopViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: ShopViewModel!
    private var rewardedAd: GADRewardedAd?
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var moveToAdsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func bindViewModel() {
        
        moveToAdsButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.loadGoogleAds(rewardedAd)
            }).disposed(by: rx.disposeBag)
        
        cancelButton.rx.action = viewModel.cancelAction
    }
}

// MARK: Setup
private extension ShopViewController {
    private func setup() {
        setupGoogleAds()
    }
    
    private func setupGoogleAds() {
        let request = GADRequest()
        // 하기 ID는 Test ID로 앱 베포시에 변경해야 함!
        GADRewardedAd.load(withAdUnitID: IdentiferAD.test, request: request) { ads, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.rewardedAd = ads
                print("Ad Loaded")
                self.rewardedAd?.fullScreenContentDelegate = self
            }
        }
    }
    
    private func loadGoogleAds(_ status: GADRewardedAd?) {
        guard status != nil else { return }
        rewardedAd?.present(fromRootViewController: self) {
            print("Get Moeny")
        }
    }
}

// MARK: Google Ads
extension ShopViewController: GADFullScreenContentDelegate {
    // swiftlint:disable:next identifier_name
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ads dismissed")
        setupGoogleAds()
    }
}
