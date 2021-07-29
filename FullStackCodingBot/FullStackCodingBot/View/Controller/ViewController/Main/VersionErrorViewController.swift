import UIKit

class VersionErrorViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: RankViewModel!
    @IBOutlet weak var closeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func bindViewModel() {
        closeButton.rx.action = viewModel.cancelAction
    }
}
