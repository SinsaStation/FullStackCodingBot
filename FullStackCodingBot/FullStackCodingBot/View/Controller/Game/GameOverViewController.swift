import UIKit

final class GameOverViewController: UIViewController, ViewModelBindableType {
    
    @IBOutlet var buttonController: GameOverButtonController!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var gainedCoinLabel: UILabel!
    @IBOutlet weak var totalCoinLabel: UILabel!
    @IBOutlet var backgroundView: ReplicateAnimationView!
    
    var viewModel: GameOverViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.execute()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        backgroundView.draw(withImage: .gameover)
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
