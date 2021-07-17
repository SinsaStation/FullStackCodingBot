import UIKit

final class PauseViewController: UIViewController, ViewModelBindableType {

    @IBOutlet var buttonController: PauseButtonController!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var backgroundView: ReplicateAnimationView!
    
    var viewModel: PauseViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        backgroundView.draw(withImage: .paused)
    }
    
    func bindViewModel() {
        buttonController.setupButton()
        buttonController.bind { [unowned self] viewController in
            self.viewModel.makeMoveAction(to: viewController)
        }
        
        scoreLabel.text = "\(viewModel.currentScore)"
    }
}
