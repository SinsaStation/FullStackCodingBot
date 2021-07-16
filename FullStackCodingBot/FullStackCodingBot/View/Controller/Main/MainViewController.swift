import UIKit
import GhostTypewriter

final class MainViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: MainViewModel!
    @IBOutlet var buttonController: MainButtonController!
    @IBOutlet weak var titleLabel: TypewriterLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTitleLabel()
        titleLabel.startTypewritingAnimation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleLabel.restartTypewritingAnimation()
    }
    
    private func setupTitleLabel() {
        titleLabel.font = .systemFont(ofSize: view.bounds.width * 0.04)
        titleLabel.text = Text.title
    }
    
    func bindViewModel() {
        buttonController.setupButton()
        buttonController.bind { [unowned self] viewController in
            self.viewModel.makeMoveAction(to: viewController)
        }
    }
}
