import UIKit

final class PauseViewController: UIViewController, ViewModelBindableType {

    @IBOutlet var buttonController: PauseButtonController!
    @IBOutlet var scoreLabel: UILabel!
    
    var viewModel: PauseViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func bindViewModel() {
        buttonController.setupButton()
        buttonController.bind { [unowned self] viewController in
            self.viewModel.makeMoveAction(to: viewController)
        }
        
        scoreLabel.text = "\(viewModel.currentScore)"
    }
}
