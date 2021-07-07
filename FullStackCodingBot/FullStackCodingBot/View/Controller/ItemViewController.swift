import UIKit
import RxSwift
import RxCocoa

final class ItemViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: ItemViewModel!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func bindViewModel() {
        
//        viewModel.itemStorage
//            .bind(to: <#T##[Unit]...##[Unit]#>)
        
        cancelButton.rx.action = viewModel.cancelAction
    }
}
