import UIKit

final class SettingViewController: UIViewController, ViewModelBindableType {

    var viewModel: MainViewModel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var bgmSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func bindViewModel() {
        cancelButton.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                self.viewModel.makeCloseAction()
            }).disposed(by: rx.disposeBag)
        
        viewModel.bgmSwitchState
            .asDriver(onErrorJustReturn: true)
            .drive(bgmSwitch.rx.isOn)
            .disposed(by: rx.disposeBag)
        
        bgmSwitch.rx.isOn
            .subscribe(onNext: { [unowned self] state in
                self.viewModel.setupBGMState(state)
            }).disposed(by: rx.disposeBag)
    }
}
