import UIKit

final class ItemViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: ItemViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func bindViewModel() {
        print("\(self)")
    }
}
