import UIKit
import RxSwift
import RxCocoa

final class MainViewController: UIViewController, ViewModelBindableType {
   
    var viewModel: MainViewModel!
    @IBOutlet var buttonController: ButtonController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func bindViewModel() {
        print("\(self)")
    }
    
}

private extension MainViewController {
    
    private func setup() {
        setupButtonController()
    }
    
    private func setupButtonController() {
        buttonController.setupButton()
        buttonController.bind { [unowned self] viewController in
            self.viewModel.makeMoveAction(to: viewController)
        }
    }
}
