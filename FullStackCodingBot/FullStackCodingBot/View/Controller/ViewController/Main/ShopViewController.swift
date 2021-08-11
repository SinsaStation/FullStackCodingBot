import UIKit
import RxSwift
import RxCocoa
import GoogleMobileAds

final class ShopViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: ShopViewModel!
    @IBOutlet weak var totalCoinLabel: UILabel!
    @IBOutlet weak var infoView: FadeInTextView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var shopCollectionView: UICollectionView!
    
    private lazy var itemWidth = shopCollectionView.frame.width * 0.3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        infoView.show(text: Text.shopReset)
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
                self.infoView.show(text: Text.reward(amount: reward))
            }).disposed(by: rx.disposeBag)

        cancelButton.rx.action = viewModel.cancelAction
    }
    
    private func action(for item: ShopItem) {
        switch item {
        case .adMob(let adMob):
            self.show(adMob)
        case .gift:
            self.viewModel.giftTaken()
        case .taken:
            self.infoView.show(text: Text.giftTaken)
        case .loading:
            self.infoView.show(text: Text.giftLoading)
        }
    }
}

// MARK: Setup
private extension ShopViewController {
    private func setup() {
        setInfoViewObserver()
        setupDelegate()
    }
    
    private func setInfoViewObserver() {
        infoView.rx.observe(CGRect.self, "bounds")
            .subscribe(onNext: { [unowned self ] _ in
                self.infoView.layoutSubviews(with: Text.shopReset)
            }).disposed(by: rx.disposeBag)
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
        let width = itemWidth
        let height = width
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let xInset = (shopCollectionView.frame.width - itemWidth * 3) / 2.5
        return UIEdgeInsets(top: 0, left: xInset, bottom: 0, right: xInset)
    }
}

// MARK: Google Ads
extension ShopViewController: GADFullScreenContentDelegate {
    private func show(_ adMob: GADRewardedAd) {
        adMob.fullScreenContentDelegate = self
        
        adMob.present(fromRootViewController: self) { [unowned self] in
            self.viewModel.adDidFinished(adMob)
        }
    }
}
