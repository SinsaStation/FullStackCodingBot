import Foundation
import RxSwift
import GoogleMobileAds

protocol StorageType {
    
    func initializeData(using uuid: String?, isFirstLaunched: Bool) -> Observable<Bool>
    
    // Shop
    func availableRewards() -> Observable<[ShopItem]>
    func availableMoney() -> Observable<Int> // + Item
    func setNewRewardsIfPossible() -> Observable<Bool>
    func rewardNeedsToBeGiven(with finishedAd: GADRewardedAd?) -> Int
    
    // Item
    func itemList() -> [Unit]
    func raiseLevel(of unit: Unit, using money: Int) -> Unit
    
    // Game
    func myHighScore() -> Int
    
    // GameOver
    func raiseMoney(by amount: Int)
    func updateHighScore(new score: Int) -> Bool
    
    // Background
    func save()
}
