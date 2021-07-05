import UIKit

final class MainViewController: UIViewController {
    
    @IBOutlet var buttonController: ButtonController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
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
