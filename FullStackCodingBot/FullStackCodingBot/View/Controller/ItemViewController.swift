import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

final class ItemViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: ItemViewModel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var itemCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func bindViewModel() {
        
        viewModel.itemStorage
            .drive(itemCollectionView.rx.items(cellIdentifier: ItemCell.identifier, cellType: ItemCell.self)) { _, unit, cell in
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
    }
}

// MARK: Setup CellSize
extension ItemViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = itemCollectionView.frame.width * 0.3
        let height = itemCollectionView.frame.height * 0.8
        return CGSize(width: width, height: height)
    }
}
