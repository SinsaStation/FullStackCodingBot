import UIKit

class GameViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: GameViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func bindViewModel() {
        print("\(self)")
    }
}
