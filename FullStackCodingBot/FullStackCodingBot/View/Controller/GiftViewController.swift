import UIKit

final class GiftViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: GiftViewModel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func bindViewModel() {
        
        cancelButton.rx.action = viewModel.cancelAction
    }
}
