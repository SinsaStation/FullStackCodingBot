import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx
import GhostTypewriter

final class ItemViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: ItemViewModel!
    @IBOutlet weak var infoView: FadeInTextView!
    @IBOutlet weak var mainItemView: MainItemView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var itemCollectionView: UICollectionView!
    @IBOutlet weak var levelUpButton: LevelUpButton!
    @IBOutlet weak var availableMoneyLabel: UILabel!
    
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
        
        viewModel.status
            .subscribe(onNext: { [unowned self] message in
                self.infoView.show(text: message)
            }).disposed(by: rx.disposeBag)
        
        cancelButton.rx.action = viewModel.cancelAction
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        guard let objectView = object as? FadeInTextView,
              objectView === infoView,
              keyPath == #keyPath(UIView.bounds) else { return }
        infoView.layoutSubviews(with: Text.levelUp)
    }
}

// MARK: Setup
private extension ItemViewController {
    private func setup() {
        setInfoViewObserver()
        setupDelegate()
        setupButtonAction()
    }
    
    private func setInfoViewObserver() {
        infoView.addObserver(self, forKeyPath: #keyPath(UIView.bounds), options: .new, context: nil)
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
