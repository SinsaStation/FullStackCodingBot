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
    @IBOutlet weak var loadingView: LoadingView!
    @IBOutlet weak var rewardPopupView: RewardPopupView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        titleView.clear()
    }

    func bindViewModel() {
        buttonController.setupButton()
        buttonController.bind { [unowned self] viewController in
            self.viewModel.makeMoveAction(to: viewController)
        }
        
        viewModel.firebaseDidLoad
            .subscribe(onNext: { [unowned self] isLoaded in
                guard isLoaded else { return }
                self.unsetLoadingView()
            }).disposed(by: rx.disposeBag)
        
        viewModel.rewardAvailable
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [unowned self] isAvailable in
                self.setRewardPopup(withState: isAvailable)
            }).disposed(by: rx.disposeBag)
    }
}

// setup
extension MainViewController {
    private func setup() {
        setTitleViewObserver()
        setBanner()
        setLoadingView()
    }
    
    private func setLoadingView() {
        loadingView.setup()
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
    
    private func unsetLoadingView() {
        loadingView.hide()
    }
    
    private func setRewardPopup(withState isAvailable: Bool) {
        isAvailable ? rewardPopupView.show() : rewardPopupView.hide()
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
