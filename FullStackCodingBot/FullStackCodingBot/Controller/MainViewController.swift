import UIKit

final class MainViewController: UIViewController, ViewModelBindableType {
   
    var viewModel: MainViewModel!
    @IBOutlet var buttonController: ButtonController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func bindViewModel() {
        <#code#>
    }
    
}

private extension MainViewController {
    
    private func setup() {
        setupButtonController()
    }
    
    private func setupButtonController() {
        buttonController.setupButton()
        buttonController.bind { type in
            
        }
    }
}
