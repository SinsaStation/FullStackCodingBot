import UIKit
import RxSwift
import RxCocoa
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
        titleView.rx.observe(CGRect.self, "bounds")
            .subscribe(onNext: { [unowned self ] _ in
                self.titleView.layoutSubviews(with: Text.title)
            }).disposed(by: rx.disposeBag)
    }
}
