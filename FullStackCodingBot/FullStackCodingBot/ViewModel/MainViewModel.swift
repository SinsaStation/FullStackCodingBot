import Foundation
import RxSwift

final class MainViewModel: AdViewModel {
        
    func fetchGameData(firstLaunched: Bool, units: [Unit], money: Int, score: Int) {
        switch firstLaunched {
        case true:
            getUserInformation()
        case false:
            storage.initializeData(units, money, score)
            adStorage.updateIfPossible()
        }
    }
    
    func makeMoveAction(to viewController: ViewControllerType) {
        switch viewController {
        case .giftVC:
            let shopViewModel = ShopViewModel(sceneCoordinator: self.sceneCoordinator, storage: self.storage, adStorage: adStorage, database: database)
            let shopScene = Scene.shop(shopViewModel)
            self.sceneCoordinator.transition(to: shopScene, using: .fullScreen, with: StoryboardType.main, animated: true)
            
        case .rankVC:
            let rankViewModel = RankViewModel(sceneCoordinator: self.sceneCoordinator, storage: self.storage, database: database)
            let rankScene = Scene.rank(rankViewModel)
            self.sceneCoordinator.transition(to: rankScene, using: .fullScreen, with: StoryboardType.main, animated: true)
            
        case .itemVC:
            let itemViewModel = ItemViewModel(sceneCoordinator: self.sceneCoordinator, storage: self.storage, database: database)
            let itemScene = Scene.item(itemViewModel)
            self.sceneCoordinator.transition(to: itemScene, using: .fullScreen, with: StoryboardType.main, animated: true)
            
        case .gameVC:
            let gameUnitManager = GameUnitManager(allKinds: self.storage.itemList())
            let gameViewModel = GameViewModel(sceneCoordinator: self.sceneCoordinator, storage: self.storage, database: database, gameUnitManager: gameUnitManager)
            let gameScene = Scene.game(gameViewModel)
            self.sceneCoordinator.transition(to: gameScene, using: .fullScreen, with: StoryboardType.game, animated: true)
        }
    }
    
    private func getUserInformation() {
        database.getFirebaseData()
            .subscribe(onNext: { [unowned self] data in
                self.updateDatabaseInformation(data)
            }, onError: { error in
                print(error)
            }, onCompleted: { [unowned self] in
                self.storage.didLoaded()
            }).disposed(by: rx.disposeBag)
    }
    
    private func updateDatabaseInformation(_ info: NetworkDTO) {
        info.units.forEach { storage.append(unit: $0) }
        storage.raiseMoney(by: info.money)
        storage.updateHighScore(new: info.score)
        adStorage.updateAdsInformation(info.ads)
    }
}
