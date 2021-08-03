import UIKit

final class SettingViewController: UIViewController, ViewModelBindableType {

    var viewModel: MainViewModel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet var settingSwitchController: SettingSwitchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func bindViewModel() {
        
        settingSwitchController.setupSwitch()
        settingSwitchController.bind { settingInfo in
            print(settingInfo)
        }
        
        cancelButton.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                self.viewModel.makeCloseAction()
            }).disposed(by: rx.disposeBag)
    }
}
