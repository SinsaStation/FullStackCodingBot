import UIKit
import RxSwift
import GhostTypewriter
import GameKit
import Firebase

final class MainViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: MainViewModel!
    @IBOutlet var buttonController: MainButtonController!
    @IBOutlet weak var skyView: SkyView!
    @IBOutlet weak var titleView: TypeWriterView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitleViewObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleView.show(text: Text.title)
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
    
    private func setTitleViewObserver() {
        titleView.addObserver(self, forKeyPath: #keyPath(UIView.bounds), options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        guard let objectView = object as? TypeWriterView,
              objectView === titleView,
              keyPath == #keyPath(UIView.bounds) else { return }
        titleView.layoutSubviews(with: Text.title)
    }
}
