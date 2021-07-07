import UIKit

final class MainViewController: UIViewController, ViewModelBindableType {
   
    var viewModel: MainViewModel!
    @IBOutlet var buttonController: ButtonController!
    
    func bindViewModel() {
       buttonController.setupButton()
        buttonController.bind { [unowned self] viewController in
            self.viewModel.makeMoveAction(to: viewController)
        }
    }
}
