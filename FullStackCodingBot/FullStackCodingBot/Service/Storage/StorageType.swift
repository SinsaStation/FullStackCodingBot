import Foundation
import RxSwift
import GoogleMobileAds

protocol StorageType {
    
    func initializeData(using uuid: String?, isFirstLaunched: Bool) -> Observable<Bool>
    
    // 우선 나열해보자
    // Shop
    func avilableRewards() -> Observable<[ShopItem]>
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
    
    func save()
}
