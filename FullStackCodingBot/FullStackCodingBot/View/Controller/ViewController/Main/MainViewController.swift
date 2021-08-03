import UIKit
import RxSwift
import GhostTypewriter
import GameKit
import Firebase

final class MainViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: MainViewModel!
    @IBOutlet var buttonController: MainButtonController!
    @IBOutlet weak var titleLabel: TypewriterLabel!
    @IBOutlet weak var skyView: SkyView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleLabel.restartTypewritingAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        skyView.startCloudAnimation()
    }

    func bindViewModel() {
        buttonController.setupButton()
        buttonController.bind { [unowned self] viewController in
            self.viewModel.makeMoveAction(to: viewController)
        }
        
        viewModel.firebaseDidLoad
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [unowned self] isLoaded in
                if !isLoaded { self.viewModel.startLoading() }
            }).disposed(by: rx.disposeBag)
    }
}

// MARK: Setup
private extension MainViewController {
    
    private func setup() {
        setupTitleLabel()
        titleLabel.startTypewritingAnimation()
    }
        
    private func setupTitleLabel() {
        let font = UIFont(name: Font.joystix, size: view.bounds.width * 0.04) ?? UIFont()
        let attributedString = NSMutableAttributedString(string: Text.title)
        attributedString.addAttribute(.font, value: font, range: .init(location: 0, length: Text.title.count))
        titleLabel.attributedText = attributedString
    }
}
