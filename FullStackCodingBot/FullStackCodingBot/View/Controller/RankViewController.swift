import UIKit

final class RankViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: RankViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func bindViewModel() {
        print("\(self)")
    }
}
