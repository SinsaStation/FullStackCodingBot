import UIKit

final class SettingViewController: UIViewController, ViewModelBindableType {

    var viewModel: MainViewModel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var storyButton: UIButton!
    @IBOutlet var settingSwitchController: SettingSwitchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func bindViewModel() {
        settingSwitchController.setupSwitch()
        settingSwitchController.bind { [unowned self] settingInfo in
            self.viewModel.setupBGMState(settingInfo)
        }
        
        cancelButton.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                self.viewModel.makeCloseAction()
            }).disposed(by: rx.disposeBag)
        
        viewModel.settingSwitchState
            .subscribe(onNext: { [unowned self] state in
                self.settingSwitchController.setupState(state)
            }).disposed(by: rx.disposeBag)
        
        storyButton.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                self.viewModel.makeMoveAction(to: .storyVC)
            }).disposed(by: rx.disposeBag)
    }
}
