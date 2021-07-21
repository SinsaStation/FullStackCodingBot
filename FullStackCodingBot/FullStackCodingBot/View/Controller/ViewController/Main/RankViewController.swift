import UIKit

final class RankViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: RankViewModel!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func bindViewModel() {
        cancelButton.rx.action = viewModel.cancelAction
    }
}
