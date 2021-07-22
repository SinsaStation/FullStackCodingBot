import Foundation
import RxSwift
import RxCocoa
import Action
import GoogleMobileAds

final class ShopViewModel: AdViewModel {
    
    let confirmAction: Action<String, Void>
    let cancelAction: CocoaAction
    
    var itemStorage: Driver<[ShopItem]> {
        return adStorage.availableItems().asDriver(onErrorJustReturn: [])
    }
    
    lazy var selectedItem = BehaviorRelay<ShopItem?>(value: nil)
    
    lazy var currentMoney: Driver<String> = {
        return storage.availableMoeny().map {String($0)}.asDriver(onErrorJustReturn: "")
    }()
    
    init(sceneCoordinator: SceneCoordinatorType, storage: ItemStorageType, adStorage: AdStorageType, confirmAction: Action<String, Void>? = nil, cancelAction: CocoaAction? = nil) {
        
        self.confirmAction = Action<String, Void> { input in
            if let action = confirmAction {
                action.execute(input)
            }
            return sceneCoordinator.close(animated: true).asObservable().map { _ in }
        }
        
        self.cancelAction = CocoaAction {
            if let action = cancelAction {
                action.execute(())
            }
            return sceneCoordinator.close(animated: true).asObservable().map { _ in }
        }
        
        super.init(sceneCoordinator: sceneCoordinator, storage: storage, adStorage: adStorage)
    }
    
    func giftTaken() {
        adStorage.giftTaken()
        addCoin()
    }
    
    private func addCoin() {
        let moneyToRaise = ShopSetting.reward()
        storage.raiseMoney(by: moneyToRaise)
    }
    
    func adDidFinished(_ finishedAd: GADRewardedAd) {
        adStorage.adDidFinished(finishedAd)
        addCoin()
    }
}
