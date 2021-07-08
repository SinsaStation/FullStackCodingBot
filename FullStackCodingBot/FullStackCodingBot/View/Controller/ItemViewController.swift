import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

final class ItemViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: ItemViewModel!
    
    @IBOutlet weak var mainItemView: MainItemView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var itemCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func bindViewModel() {
        
        viewModel.itemStorage
            .drive(itemCollectionView.rx.items(cellIdentifier: ItemCell.identifier, cellType: ItemCell.self)) { [unowned self] row, unit, cell in
                if row == 0 { self.mainItemView.configure(unit) }
                cell.configure(unit: unit)
            }.disposed(by: rx.disposeBag)
        
        cancelButton.rx.action = viewModel.cancelAction
    }
}

// MARK: Setup
private extension ItemViewController {
    
    private func setup() {
        setupDelegate()
    }
    
    private func setupDelegate() {
        itemCollectionView.rx.setDelegate(self).disposed(by: rx.disposeBag)
        
        itemCollectionView.rx.modelSelected(Unit.self)
            .subscribe(onNext: { [unowned self] unit in
                self.mainItemView.configure(unit)
            }).disposed(by: rx.disposeBag)
    }
}

// MARK: Setup CellSize
extension ItemViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = itemCollectionView.frame.width * 0.3
        let height = itemCollectionView.frame.height * 0.8
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let xInset = itemCollectionView.frame.width * 0.05
        return UIEdgeInsets(top: 0, left: xInset, bottom: xInset, right: 0)
    }
}
