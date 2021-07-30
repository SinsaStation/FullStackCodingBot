import UIKit
import RxSwift

class LoadingViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: MainViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func bindViewModel() {
        viewModel.firebaseDidLoad
            .subscribe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { isLoaded in
                if isLoaded {
                    self.viewModel.makeCloseAction()
                }
            }).disposed(by: rx.disposeBag)
    }
}
