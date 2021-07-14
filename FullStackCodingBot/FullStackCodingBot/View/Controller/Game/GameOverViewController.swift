import UIKit

final class GameOverViewController: UIViewController, ViewModelBindableType {
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var gainedCoinLabel: UILabel!
    @IBOutlet weak var totalCoinLabel: UILabel!
    @IBOutlet var buttonController: GameOverButtonController!
    
    var viewModel: GameOverViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.execute()
    }
    
    func bindViewModel() {
        buttonController.setupButton()
        buttonController.bind { [unowned self] viewController in
            self.viewModel.makeMoveAction(to: viewController)
        }
        
        scoreLabel.text = "\(viewModel.finalScore)"
        gainedCoinLabel.text = "\(viewModel.moneyGained)"
        
        viewModel.currentMoney
            .subscribe(onNext: { [unowned self] currentMoney in
                self.totalCoinLabel.text = "\(currentMoney)"
        }).disposed(by: rx.disposeBag)
    }
}
