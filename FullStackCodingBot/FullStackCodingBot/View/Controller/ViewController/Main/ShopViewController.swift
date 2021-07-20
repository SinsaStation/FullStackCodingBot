import UIKit
import GoogleMobileAds
final class ShopViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: ShopViewModel!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var moveToAdsButton: UIButton!
    var rewaredAd: GADRewardedAd?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request = GADRequest()
        GADRewardedAd.load(withAdUnitID: "ca-app-pub-3940256099942544/1712485313", request: request) {ad, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.rewaredAd = ad
                print("Ad Loaded")
                self.rewaredAd?.fullScreenContentDelegate = self
            }
        }
    }
    
    func bindViewModel() {
        
        moveToAdsButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                if self.rewaredAd != nil {
                    self.rewaredAd?.present(fromRootViewController: self, userDidEarnRewardHandler: {
                        print("money money")
                    })
                }
            }).disposed(by: rx.disposeBag)
        
        cancelButton.rx.action = viewModel.cancelAction
    }
}

extension ShopViewController: GADFullScreenContentDelegate {
    
}
