import UIKit
import GoogleMobileAds

final class ShopViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: ShopViewModel!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var moveToAdsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func bindViewModel() {
        moveToAdsButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                guard let adToShow = viewModel.availableAd() else { return }
                adToShow.fullScreenContentDelegate = self
                self.load(adToShow)
            }).disposed(by: rx.disposeBag)
        
        cancelButton.rx.action = viewModel.cancelAction
    }
}

// MARK: Setup
private extension ShopViewController {
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
        viewModel.adDidFinished(with: false)
    }
    
    // swiftlint:disable:next identifier_name
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        viewModel.adDidFinished(with: true)
    }
}
