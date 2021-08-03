import UIKit
import RxSwift
import GhostTypewriter
import GameKit
import Firebase

final class MainViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: MainViewModel!
    @IBOutlet var buttonController: MainButtonController!
    @IBOutlet weak var skyView: SkyView!
    @IBOutlet weak var typeWriterView: TypeWriterView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        typeWriterView.startTyping(text: Text.title, duration: 1.0)
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
