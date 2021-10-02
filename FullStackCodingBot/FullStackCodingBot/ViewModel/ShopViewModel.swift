import Foundation
import RxSwift
import RxCocoa
import Action
import Firebase
import GoogleMobileAds

final class ShopViewModel: CommonViewModel {
    
    private let storage: RewardManagable & GameMoneyManagable
    let cancelAction: CocoaAction

    var itemStorage: Driver<[ShopItem]> {
        return storage.availableRewards().asDriver(onErrorJustReturn: [])
    }
    
    lazy var currentMoney: Driver<String> = {
        return storage.availableMoney().map { String($0) }.asDriver(onErrorJustReturn: "")
    }()
    
    lazy var selectedItem = BehaviorRelay<ShopItem?>(value: nil)
    lazy var reward = BehaviorRelay<Int?>(value: nil)
    private let soundEffectStation: SingleSoundEffectStation
        
    init(sceneCoordinator: SceneCoordinatorType,
         storage: RewardManagable & GameMoneyManagable,
         cancelAction: CocoaAction? = nil,
         soundEffectType: MainSoundEffect = .reward) {
        self.storage = storage
        self.cancelAction = CocoaAction {
            if let action = cancelAction {
                action.execute(())
            }
            return sceneCoordinator.close(animated: true).asObservable().map { _ in }
        }
        self.soundEffectStation = SingleSoundEffectStation(soundEffectType: soundEffectType)
        super.init(sceneCoordinator: sceneCoordinator)
    }
    
    func execute() {
        bindAdStorage()
    }
    
    private func bindAdStorage() {
        storage.setNewRewardsIfPossible()
            .subscribe(onError: { error in
                        Firebase.Analytics.logEvent("RewardsError", parameters: ["ErrorMessage": "\(error)"])})
            .disposed(by: rx.disposeBag)
    }
    
    func adDidFinished(_ finishedAd: GADRewardedAd) {
        let reward = storage.rewardNeedsToBeGiven(with: finishedAd)
        addCoin(by: reward)
    }
    
    func giftTaken() {
        let reward = storage.rewardNeedsToBeGiven(with: nil)
        addCoin(by: reward)
    }
    
    private func addCoin(by amount: Int) {
        reward.accept(amount)
        soundEffectStation.play()
    }
}
