import UIKit
import RxCocoa

final class GameOverViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: GameOverViewModel!
    
    @IBOutlet var buttonController: GameOverButtonController!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var gainedCoinLabel: UILabel!
    @IBOutlet weak var totalCoinLabel: UILabel!
    @IBOutlet weak var highScoreImageView: UIImageView!
    @IBOutlet var backgroundView: ReplicateAnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SoundStation.shared.musicStop()
        viewModel.execute()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    }
}
