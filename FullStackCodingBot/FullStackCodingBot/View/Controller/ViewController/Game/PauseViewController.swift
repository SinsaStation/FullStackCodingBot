import UIKit
import GoogleMobileAds

final class PauseViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: PauseViewModel!
    @IBOutlet var buttonController: PauseButtonController!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var backgroundView: ReplicateAnimationView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bannerView.load(GADRequest())
        backgroundView.draw(withImage: .paused, countPerLine: 3.2)
    }

    func bindViewModel() {
        buttonController.setupButton()
        buttonController.bind { [unowned self] viewController in
            self.viewModel.makeMoveAction(to: viewController)
        }
        
        viewModel.currentScoreInfo
            .drive(scoreLabel.rx.text)
            .disposed(by: rx.disposeBag)
    }
}

// setup
extension PauseViewController {
    private func setup() {
        setBanner()
        setupFont()
    }
    
    private func setBanner() {
        bannerView.adUnitID = IdentiferAD.banner
        bannerView.rootViewController = self
        bannerView.delegate = self
    }
    
    private func setupFont() {
        scoreLabel.font = UIFont.joystix(style: .title2)
    }
}

// Google Ads
extension PauseViewController: GADBannerViewDelegate {
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.alpha = 0
        UIView.animate(withDuration: 0.8, animations: {
            bannerView.alpha = 1
        })
    }
}
