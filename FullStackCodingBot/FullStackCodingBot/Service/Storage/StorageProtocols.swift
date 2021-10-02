import Foundation
import RxSwift
import GoogleMobileAds

typealias StorageType = GameDataManagable & GameItemManagable & GameMoneyManagable & HighScoreManagable & RewardManagable

protocol GameDataManagable {
    func initializeData(using uuid: String?, isFirstLaunched: Bool) -> Observable<Bool>
    func save()
}

protocol GameItemManagable {
    func itemList() -> [Unit]
    func raiseLevel(of unit: Unit, using money: Int) -> Unit
}

protocol GameMoneyManagable {
    func availableMoney() -> Observable<Int>
    func raiseMoney(by amount: Int)
}

protocol HighScoreManagable {
    func myHighScore() -> Int
    func updateHighScore(new score: Int) -> Bool
}

protocol RewardManagable {
    func availableRewards() -> Observable<[ShopItem]>
    func setNewRewardsIfPossible() -> Observable<Bool>
    func rewardNeedsToBeGiven(with finishedAd: GADRewardedAd?) -> Int
}
