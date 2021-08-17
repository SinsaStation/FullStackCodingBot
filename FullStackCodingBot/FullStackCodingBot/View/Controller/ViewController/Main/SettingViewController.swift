import UIKit
import RxSwift

final class SettingViewController: UIViewController, ViewModelBindableType {

    var viewModel: MainViewModel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var storyButton: UIButton!
    @IBOutlet var settingSwitchController: SettingSwitchController!
    @IBOutlet weak var dismissView: UIView!
    @IBOutlet var settingLabels: [UILabel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
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

// setup
extension SettingViewController {
    private func setup() {
        setupFont()
        setupDismissGesture()
    }
    
    private func setupFont() {
        settingLabels.forEach { label in
            label.font = UIFont.joystix(style: .body)
        }
    }
    
    private func setupDismissGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(respondToTapGesture(_:)))
        dismissView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func respondToTapGesture(_ sender: UIView) {
        viewModel.makeCloseAction()
    }
}
