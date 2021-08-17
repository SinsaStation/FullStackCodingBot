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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
    }
    
    private func setupFont() {
        scoreLabel.font = UIFont.joystix(style: .title2)
    }
}
