import UIKit

final class PauseViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: PauseViewModel!
    
    @IBOutlet var buttonController: PauseButtonController!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var backgroundView: ReplicateAnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
