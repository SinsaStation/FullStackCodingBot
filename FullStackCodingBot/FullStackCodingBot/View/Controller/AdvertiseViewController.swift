import UIKit

final class AdvertiseViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: AdvertiseViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func bindViewModel() {
        print(1)
    }
}
