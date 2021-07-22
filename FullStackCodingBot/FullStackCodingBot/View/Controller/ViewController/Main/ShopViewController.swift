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
                switch item {
                case .adMob(let adMob):
                    self.show(adMob)
                case .gift:
                    self.rewarded()
                }
            }).disposed(by: rx.disposeBag)
        
        viewModel.currentMoney
            .drive(totalCoinLabel.rx.text)
            .disposed(by: rx.disposeBag)

        cancelButton.rx.action = viewModel.cancelAction
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
        let width = shopCollectionView.frame.width * 0.3
        let height = width
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let heightInset = shopCollectionView.frame.height - (shopCollectionView.frame.width * 0.6)
        return UIEdgeInsets(top: heightInset/2, left: 0, bottom: heightInset/2, right: 0)
    }
}

// MARK: Google Ads
extension ShopViewController: GADFullScreenContentDelegate {
    
    private func rewarded() {
        viewModel.addCoin()
    }
    
    private func show(_ adMob: GADRewardedAd) {
        adMob.fullScreenContentDelegate = self
        
        adMob.present(fromRootViewController: self) { [unowned self] in
            self.rewarded()
        }
    }
    
    // swiftlint:disable:next identifier_name
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        viewModel.adDidFinished(with: false)
    }
    
    // swiftlint:disable:next identifier_name
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        viewModel.adDidFinished(with: true)
    }
}
