import UIKit

final class ShopViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: ShopViewModel!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func bindViewModel() {
        cancelButton.rx.action = viewModel.cancelAction
    }
}
