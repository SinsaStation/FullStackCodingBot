import UIKit
import RxSwift

class LoadingViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: MainViewModel!
    
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func bindViewModel() {
        viewModel.firebaseDidLoad
            .subscribe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: {[unowned self] isLoaded in
                if isLoaded {
                    self.loadingSpinner.stopAnimating()
                    self.viewModel.makeCloseAction()
                }
            }).disposed(by: rx.disposeBag)
    }
}
