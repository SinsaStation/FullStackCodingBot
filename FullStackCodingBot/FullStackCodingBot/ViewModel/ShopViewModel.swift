import Foundation
import RxSwift
import RxCocoa
import Action
import Firebase
import GoogleMobileAds

final class ShopViewModel: AdViewModel {
    
    let cancelAction: CocoaAction

    var itemStorage: Driver<[ShopItem]> {
        return adStorage.availableItems().asDriver(onErrorJustReturn: [])
    }
    
    lazy var currentMoney: Driver<String> = {
        return storage.availableMoeny().map {String($0)}.asDriver(onErrorJustReturn: "")
    }()
    
    lazy var selectedItem = BehaviorRelay<ShopItem?>(value: nil)
    lazy var reward = BehaviorRelay<Int?>(value: nil)
    private let soundEffectStation: SingleSoundEffectStation
        
    init(sceneCoordinator: SceneCoordinatorType,
         storage: PersistenceStorageType,
         adStorage: AdStorageType,
         database: FirebaseManagerType,
         cancelAction: CocoaAction? = nil,
         soundEffectType: MainSoundEffect = .reward) {
        self.cancelAction = CocoaAction {
            if let action = cancelAction {
                action.execute(())
            }
            return sceneCoordinator.close(animated: true).asObservable().map { _ in }
        }
        self.soundEffectStation = SingleSoundEffectStation(soundEffectType: soundEffectType)
        super.init(sceneCoordinator: sceneCoordinator, storage: storage, adStorage: adStorage, database: database)
    }
    
    func execute() {
        bindAdStorage()
    }
    
    private func bindAdStorage() {
        adStorage.setNewRewardsIfPossible(with: .none)
            .subscribe(onError: { error in
                        Firebase.Analytics.logEvent("RewardsError", parameters: ["ErrorMessage": "\(error)"])})
            .disposed(by: rx.disposeBag)
    }
    
    func adDidFinished(_ finishedAd: GADRewardedAd) {
        adStorage.adDidFinished(finishedAd)
        addCoin()
    }
    
    func giftTaken() {
        adStorage.giftTaken()
        addCoin()
    }
    
    private func addCoin() {
        let moneyToRaise = ShopSetting.reward()
        storage.raiseMoney(by: moneyToRaise)
        reward.accept(moneyToRaise)
        soundEffectStation.play()
    }
}
