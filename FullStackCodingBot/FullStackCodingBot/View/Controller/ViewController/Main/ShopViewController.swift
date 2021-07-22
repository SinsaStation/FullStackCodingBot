import UIKit
import RxSwift
import RxCocoa
import GoogleMobileAds

final class ShopViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: ShopViewModel!
    
    @IBOutlet weak var totalCoinLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var shopCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func bindViewModel() {
        viewModel.itemStorage
            .drive(shopCollectionView.rx.items(cellIdentifier: ShopCell.identifier, cellType: ShopCell.self)) { _, item, cell in
                cell.configure(item: item)
            }.disposed(by: rx.disposeBag)

        viewModel.selectedItem
            .subscribe(onNext: { [unowned self] item in
                guard let item = item else { return }
                self.action(for: item)
            }).disposed(by: rx.disposeBag)
        
        viewModel.currentMoney
            .drive(totalCoinLabel.rx.text)
            .disposed(by: rx.disposeBag)
        
        viewModel.reward
            .subscribe(onNext: { [unowned self] reward in
                guard let reward = reward else { return }
                print("리워드를 받았다!", reward)
            }).disposed(by: rx.disposeBag)

        cancelButton.rx.action = viewModel.cancelAction
    }
    
    private func action(for item: ShopItem) {
        switch item {
        case .adMob(let adMob):
            self.show(adMob)
        case .gift(let number):
            self.giftTaken(number)
        case .taken:
            print("이미 없어진 기프트!")
        }
    }
}

// MARK: Setup
private extension ShopViewController {
    private func setup() {
        setupDelegate()
    }
    
    private func setupDelegate() {
        shopCollectionView.rx.setDelegate(self).disposed(by: rx.disposeBag)
        
        shopCollectionView.rx.modelSelected(ShopItem.self)
            .subscribe(onNext: { [unowned self] item in
                self.viewModel.selectedItem.accept(item)
            }).disposed(by: rx.disposeBag)
    }
    
}

// MARK: Setup CellSize
extension ShopViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = shopCollectionView.frame.width * 0.33
        let height = width
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let yInset = (shopCollectionView.frame.height - (shopCollectionView.frame.width * 0.66)) / 2
        return UIEdgeInsets(top: yInset, left: 0, bottom: yInset, right: 0)
    }
}

// MARK: Google Ads
extension ShopViewController: GADFullScreenContentDelegate {
    private func giftTaken(_ takenGift: Int) {
        viewModel.giftTaken(takenGift)
    }
    
    private func show(_ adMob: GADRewardedAd) {
        adMob.fullScreenContentDelegate = self
        
        adMob.present(fromRootViewController: self) { [unowned self] in
            self.viewModel.adDidFinished(adMob)
        }
    }
}
