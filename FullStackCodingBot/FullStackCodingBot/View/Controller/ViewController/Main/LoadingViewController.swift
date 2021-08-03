import UIKit
import RxSwift

final class LoadingViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: MainViewModel!
    @IBOutlet weak var firebaseLoadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func bindViewModel() {
        
        viewModel.setupAppleGameCenterLogin()
        
        viewModel.firebaseDidLoad
            .subscribe(onNext: { [unowned self] isLoaded in
                if isLoaded {
                    self.firebaseLoadingIndicator.stopAnimating()
                    self.viewModel.makeCloseAction()
                }
            }).disposed(by: rx.disposeBag)
    }
}
