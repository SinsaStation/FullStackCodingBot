import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

final class ItemViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: ItemViewModel!
    @IBOutlet weak var infoView: FadeInTextView!
    @IBOutlet weak var mainItemView: MainItemView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var itemCollectionView: UICollectionView!
    @IBOutlet weak var levelUpButton: LevelUpButton!
    @IBOutlet weak var availableMoneyLabel: UILabel!
    private var feedbackGenerator: UINotificationFeedbackGenerator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        infoView.show(text: Text.levelUp)
    }
    
    func bindViewModel() {
        viewModel.itemStorage
            .drive(itemCollectionView.rx.items(cellIdentifier: ItemCell.identifier, cellType: ItemCell.self)) { _, unit, cell in
                cell.configure(unit: unit)
            }.disposed(by: rx.disposeBag)
        
        viewModel.selectedUnit
            .subscribe(onNext: { [unowned self] unit in
                self.setupItemInfomation(from: unit)
            }).disposed(by: rx.disposeBag)
        
        viewModel.upgradedUnit
            .subscribe(onNext: { [unowned self] _ in
                self.mainItemView.startAnimation()
            }).disposed(by: rx.disposeBag)
        
        viewModel.money
            .map { String($0) }
            .drive(availableMoneyLabel.rx.text)
            .disposed(by: rx.disposeBag)
        
        viewModel.levelUpStatus
            .subscribe(onNext: { [unowned self] status in
                self.infoView.show(text: message(for: status))
            }).disposed(by: rx.disposeBag)
        
        cancelButton.rx.action = viewModel.cancelAction
    }
    
    private func message(for status: LevelUpStatus) -> String {
        switch status {
        case .success(let unit):
            sendFeedback(type: .success)
            return Text.levelUpSuccessed(unitType: unit.name, to: unit.level)
        case .fail(let money):
            sendFeedback(type: .error)
            return Text.levelUpFailed(coinNeeded: money)
        case .info:
            return Text.levelUp
        }
    }
    
    private func sendFeedback(type feedbackType: UINotificationFeedbackGenerator.FeedbackType) {
        guard checkStatus() else { return }
        feedbackGenerator?.notificationOccurred(feedbackType)
    }
    
    private func checkStatus() -> Bool {
        let settings = try? UserDefaults.standard.getStruct(forKey: IdentifierUD.setting, castTo: SettingInformation.self)
        let soundEffectState = settings?.checkState()[2] ?? true
        return soundEffectState
    }
}

// MARK: Setup
private extension ItemViewController {
    private func setup() {
        setInfoViewObserver()
        setupDelegate()
        setupButtonAction()
        setupFeedbackGenerator()
    }
    
    private func setInfoViewObserver() {
        infoView.rx.observe(CGRect.self, "bounds")
            .subscribe(onNext: { [unowned self ] _ in
                self.infoView.layoutSubviews(with: Text.levelUp)
            }).disposed(by: rx.disposeBag)
    }
    
    private func setupDelegate() {
        itemCollectionView.rx.setDelegate(self).disposed(by: rx.disposeBag)
        
        itemCollectionView.rx.modelSelected(Unit.self)
            .subscribe(onNext: { [unowned self] unit in
                self.viewModel.selectedUnit.accept(unit)
            }).disposed(by: rx.disposeBag)
    }
    
    private func setupButtonAction() {
        levelUpButton.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                self.viewModel.makeActionLeveUp()
            }).disposed(by: rx.disposeBag)
    }
    
    private func setupFeedbackGenerator() {
        feedbackGenerator = UINotificationFeedbackGenerator()
        feedbackGenerator?.prepare()
    }
    
    private func setupItemInfomation(from unit: Unit) {
        mainItemView.configure(unit)
        levelUpButton.configure(unit)
        viewModel.checkLevelUpPrice()
    }
}

// MARK: Setup CellSize
extension ItemViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = itemCollectionView.frame.height * 0.8
        let width = height
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let yInset = itemCollectionView.frame.height * 0.1
        let xInset = itemCollectionView.frame.width * 0.05
        return UIEdgeInsets(top: yInset, left: xInset, bottom: yInset, right: xInset)
    }
}
