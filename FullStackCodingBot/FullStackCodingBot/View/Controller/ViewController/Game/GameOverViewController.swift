import UIKit
import RxSwift
import RxCocoa
import GoogleMobileAds

final class GameOverViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: GameOverViewModel!
    
    @IBOutlet var buttonController: GameOverButtonController!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var gainedCoinLabel: UILabel!
    @IBOutlet weak var totalCoinLabel: UILabel!
    @IBOutlet weak var highScoreImageView: UIImageView!
    @IBOutlet weak var dialogView: DialogView!
    @IBOutlet var backgroundView: ReplicateAnimationView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        viewModel.execute()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bannerView.load(GADRequest())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        backgroundView.draw(withImage: .gameover, countPerLine: 2.5)
    }
    
    func bindViewModel() {
        buttonController.setupButton()
        buttonController.bind { [unowned self] viewController in
            self.viewModel.makeMoveAction(to: viewController)
        }
        
        viewModel.finalScore
            .drive(scoreLabel.rx.text)
            .disposed(by: rx.disposeBag)
        
        viewModel.gainedMoney
            .drive(gainedCoinLabel.rx.text)
            .disposed(by: rx.disposeBag)
        
        viewModel.currentMoney
            .drive(totalCoinLabel.rx.text)
            .disposed(by: rx.disposeBag)
        
        viewModel.highScoreStatus
            .asDriver()
            .map { $0 ? 1.0 : 0.0 }
            .drive(highScoreImageView.rx.alpha)
            .disposed(by: rx.disposeBag)
        
        viewModel.newScript
            .delay(.milliseconds(300), scheduler: MainScheduler.asyncInstance)
            .subscribe(onNext: { [unowned self] script in
                guard let script = script else { return }
                self.dialogView.show(with: script)
            }).disposed(by: rx.disposeBag)
        
        viewModel.rankInfo
            .asDriver()
            .drive(rankLabel.rx.text)
            .disposed(by: rx.disposeBag)
    }
}

// setup
extension GameOverViewController {
    private func setup() {
        setBanner()
        setupFont()
    }
    
    private func setBanner() {
        bannerView.adUnitID = IdentiferAD.banner
        bannerView.rootViewController = self
    }
    
    private func setupFont() {
        rankLabel.font = UIFont.joystix(style: .largeTitle)
        scoreLabel.font = UIFont.joystix(style: .title2)
        gainedCoinLabel.font = UIFont.joystix(style: .body)
        totalCoinLabel.font = UIFont.joystix(style: .caption)
    }
}
