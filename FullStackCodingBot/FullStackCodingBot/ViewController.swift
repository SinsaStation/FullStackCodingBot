import UIKit

class ViewController: UIViewController {

    @IBOutlet var buttonController: ButtonController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

}

private extension ViewController {
    
    private func setup() {
        setupButtonController()
    }
    
    private func setupButtonController() {
        buttonController.setupButton()
        buttonController.bind { type in
            print(type)
        }
    }
}
