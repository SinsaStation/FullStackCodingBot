import Foundation
import RxSwift
import GoogleMobileAds

final class Storage {
    private var gameStorage: GameStorageType
    private var adStorage: AdStorageType
    private var backUpCenter: BackUpCenterType
    private var disposeBag = DisposeBag()

    init(gameStorage: GameStorageType = GameStorage(),
         adStorage: AdStorageType = AdStorage(),
         backUpCenter: BackUpCenterType = BackUpCenter()) {
        self.gameStorage = gameStorage
        self.adStorage = adStorage
        self.backUpCenter = backUpCenter
    }
}

extension Storage: GameDataManagable {
    func initializeData(using uuid: String?, isFirstLaunched: Bool) -> Observable<Bool> {
        Observable.create { [unowned self] observer in
            self.backUpCenter.load(with: uuid, isFirstLaunched)
                .observe(on: MainScheduler.asyncInstance)
                .subscribe(onNext: { data in
                    self.gameStorage.update(with: data)
                    self.adStorage.setNewRewardsIfPossible(with: data.ads)
                        .subscribe(onError: { _ in }).disposed(by: disposeBag)
                    observer.onNext(true)
                }, onError: { _ in
                    observer.onNext(false)
                }, onCompleted: {
                    observer.onNext(true)
                }).disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
    
    func save() {
        let currentData = NetworkDTO(units: gameStorage.itemList(),
                                     money: gameStorage.myMoney(),
                                     score: gameStorage.myHighScore(),
                                     ads: adStorage.currentInformation(),
                                     date: Date())
        backUpCenter.save(gameData: currentData)
    }
}

extension Storage: GameItemManagable {
    func itemList() -> [Unit] {
        return gameStorage.itemList()
    }
    
    func raiseLevel(of unit: Unit, using money: Int) -> Unit {
        let newUnit = gameStorage.raiseLevel(of: unit, using: money)
        backUpCenter.save(gameData: newUnit, gameStorage.myMoney(), .none)
        return newUnit
    }
}

extension Storage: GameMoneyManagable {
    func availableMoney() -> Observable<Int> {
        return gameStorage.availableMoney()
    }
    
    func raiseMoney(by amount: Int) {
        gameStorage.raiseMoney(by: amount)
        backUpCenter.save(gameData: .none, gameStorage.myMoney(), .none)
    }
}

extension Storage: HighScoreManagable {
    func myHighScore() -> Int {
        return gameStorage.myHighScore()
    }
    
    func updateHighScore(new score: Int) -> Bool {
        let isUpdatable = gameStorage.updateHighScore(new: score)
        if isUpdatable { backUpCenter.save(gameData: .none, .none, score) }
        return isUpdatable
    }
}

extension Storage: RewardManagable {
    func availableRewards() -> Observable<[ShopItem]> {
        return adStorage.availableItems()
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
        backUpCenter.save(gameData: .none, gameStorage.myMoney(), .none)
        return reward
    }
}
