import UIKit

final class GameOverViewController: UIViewController, ViewModelBindableType {
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var restartButton: UIButton!
    
    var viewModel: GameOverViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func bindViewModel() {
        scoreLabel.text = "\(viewModel.finalScore)"
        restartButton.rx.action = viewModel.cancelAction
    }
}
