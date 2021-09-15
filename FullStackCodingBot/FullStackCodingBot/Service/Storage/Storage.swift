import Foundation
import RxSwift
import GoogleMobileAds

final class Storage {
    
    private var gameStorage: GameStorageType
    private var adStorage: AdStorageType
    private var backUpCenter: BackUpCenterType

    init(gameStorage: GameStorageType, adStorage: AdStorageType, backUpCenter: BackUpCenterType) {
        self.gameStorage = gameStorage
        self.adStorage = adStorage
        self.backUpCenter = backUpCenter
    }
    
    func initializeData(using uuid: String?, isFirstLaunched: Bool) -> Observable<Bool> {
        Observable.create { [weak self] observer in
            self?.backUpCenter.load(with: uuid, isFirstLaunched)
                .observe(on: MainScheduler.asyncInstance)
                .subscribe(onNext: { data in
                    self?.gameStorage.update(with: data)
                    self?.adStorage.setNewRewardsIfPossible(with: data.ads)
                }, onError: { _ in
                    observer.onNext(false)
                }, onCompleted: {
                    observer.onNext(true)
                }).dispose()
            return Disposables.create()
        }
    }
}

extension Storage: StorageType {
    func avilableRewards() -> Observable<[ShopItem]> {
        return adStorage.availableItems()
    }
    
    func availableMoney() -> Observable<Int> {
        return gameStorage.availableMoney()
    }
    
    func setNewRewardsIfPossible() -> Observable<Bool> {
        return adStorage.setNewRewardsIfPossible(with: .none)
    }
    
    func rewardNeedsToBeGiven(with finishedAd: GADRewardedAd?) -> Int {
        if let finishedAd = finishedAd {
            adStorage.adDidFinished(finishedAd)
        } else {
            adStorage.giftTaken()
        }
        let reward = ShopSetting.reward()
        gameStorage.raiseMoney(by: reward)
        return reward
    }
    
    func itemList() -> [Unit] {
        return gameStorage.itemList()
    }
    
    func raiseLevel(of unit: Unit, using money: Int) -> Unit {
        return gameStorage.raiseLevel(of: unit, using: money)
    }
    
    func myHighScore() -> Int {
        return gameStorage.myHighScore()
    }
    
    func raiseMoney(by amount: Int) {
        gameStorage.raiseMoney(by: amount)
    }
    
    func updateHighScore(new score: Int) -> Bool {
        gameStorage.updateHighScore(new: score)
    }
    
    func save() {
        // backUpCenter.save
    }
}
