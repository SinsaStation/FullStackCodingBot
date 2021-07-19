import UIKit

final class GameOverViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: GameOverViewModel!
    
    @IBOutlet var buttonController: GameOverButtonController!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var gainedCoinLabel: UILabel!
    @IBOutlet weak var totalCoinLabel: UILabel!
    @IBOutlet var backgroundView: ReplicateAnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            .map {String($0)}
            .asDriver(onErrorJustReturn: "")
            .drive(scoreLabel.rx.text)
            .disposed(by: rx.disposeBag)
        
        viewModel.moneyGained
            .map {String($0)}
            .asDriver(onErrorJustReturn: "")
            .drive(gainedCoinLabel.rx.text)
            .disposed(by: rx.disposeBag)
        
        viewModel.currentMoney
            .map {String($0)}
            .asDriver(onErrorJustReturn: "")
            .drive(totalCoinLabel.rx.text)
            .disposed(by: rx.disposeBag)
    }
}
