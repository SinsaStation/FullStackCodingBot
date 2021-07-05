import UIKit

final class GiftViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: GiftViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func bindViewModel() {
        print("\(self)")
    }
}
