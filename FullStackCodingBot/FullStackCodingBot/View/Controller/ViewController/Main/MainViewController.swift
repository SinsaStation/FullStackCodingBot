import UIKit
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
        viewModel.execute()
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
    }
}

private extension MainViewController {
    
    private func setup() {
        setupAppleGameCenterLogin()
        setupTitleLabel()
        titleLabel.startTypewritingAnimation()
    }
        
    private func setupTitleLabel() {
        let font = UIFont(name: Font.joystix, size: view.bounds.width * 0.04) ?? UIFont()
        let attributedString = NSMutableAttributedString(string: Text.title)
        attributedString.addAttribute(.font, value: font, range: .init(location: 0, length: Text.title.count))
        titleLabel.attributedText = attributedString
    }
    
    private func setupAppleGameCenterLogin() {
        GKLocalPlayer.local.authenticateHandler = { gcViewController, error in
            guard error == nil else { return }
            
            if GKLocalPlayer.local.isAuthenticated {
                GameCenterAuthProvider.getCredential { credential, error in
                    guard error == nil else { return }
                    
                    Auth.auth().signIn(with: credential!) { [unowned self] user, error in
                        guard error == nil else { return }
                        
                        if let user = user {
                            //self.viewModel.getUserInformation(from: user.user.uid)
                        }
                    }
                }
            } else if let gcViewController = gcViewController {
                print(gcViewController)
            }
        }
    }
}

extension MainViewController: GKGameCenterControllerDelegate {
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        print("GCVC DID FINISHED")
    }
}
