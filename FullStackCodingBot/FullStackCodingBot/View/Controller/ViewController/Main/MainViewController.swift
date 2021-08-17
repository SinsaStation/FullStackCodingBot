import UIKit
import RxSwift
import RxCocoa
import GameKit
import Firebase
import GoogleMobileAds

final class MainViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: MainViewModel!
    @IBOutlet var buttonController: MainButtonController!
    @IBOutlet weak var skyView: SkyView!
    @IBOutlet weak var titleView: TypeWriterView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitleViewObserver()
        setBanner()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleView.show(text: Text.title)
        bannerView.load(GADRequest())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        skyView.startCloudAnimation()
    }

    func bindViewModel() {
        buttonController.setupButton()
        buttonController.bind { [unowned self] viewController in
            self.viewModel.makeMoveAction(to: viewController)
        }
    }
    
    private func setTitleViewObserver() {
        titleView.rx.observe(CGRect.self, "bounds")
            .subscribe(onNext: { [unowned self ] _ in
                self.titleView.layoutSubviews(with: Text.title)
            }).disposed(by: rx.disposeBag)
    }
    
    private func setBanner() {
        bannerView.adUnitID = IdentiferAD.banner
        bannerView.rootViewController = self
        bannerView.delegate = self
    }
}

// Google Ads
extension MainViewController: GADBannerViewDelegate {
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.alpha = 0
        UIView.animate(withDuration: 0.8, animations: {
            bannerView.alpha = 1
        })
    }
}
