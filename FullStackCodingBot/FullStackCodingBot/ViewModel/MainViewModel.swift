import Foundation

final class MainViewModel: AdViewModel {
    
    func execute() {
        adStorage.setup()
    }
    
    func makeMoveAction(to viewController: ViewControllerType) {
        switch viewController {
        case .giftVC:
            let shopViewModel = ShopViewModel(sceneCoordinator: self.sceneCoordinator, storage: self.storage, database: database, adStorage: adStorage)
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
    
    func getUserInformation(from uuid: String) {
        database.initializeDatabase(uuid)
        database.getFirebaseData(uuid)
            .subscribe(onNext: { [unowned self] data in
                data.forEach { self.storage.create(item: $0) }
            }, onError: { error in
                print(error)
            }).disposed(by: rx.disposeBag)
    }
}
