import Foundation

class MainViewModel:CommonViewModel {
    
    func makeMoveAction(to viewController: ViewControllerType) {
        switch viewController {
        case .giftVC:
            let giftViewModel = GiftViewModel(sceneCoordinator: self.sceneCoordinator)
            let giftScene = Scene.gift(giftViewModel)
            self.sceneCoordinator.transition(to: giftScene, using: .modal, animated: true)
            
        case .advertiseVC:
            let advertiseViewModel = AdvertiseViewModel(sceneCoordinator: self.sceneCoordinator)
            let advertiseScene = Scene.ad(advertiseViewModel)
            self.sceneCoordinator.transition(to: advertiseScene, using: .modal, animated: true)
            
        case .rankVC:
            let rankViewModel = RankViewModel(sceneCoordinator: self.sceneCoordinator)
            let rankScene = Scene.rank(rankViewModel)
            self.sceneCoordinator.transition(to: rankScene, using: .fullScreen, animated: true)
            
        case .itemVC:
            let itemViewModel = ItemViewModel(sceneCoordinator: self.sceneCoordinator)
            let itemScene = Scene.item(itemViewModel)
            self.sceneCoordinator.transition(to: itemScene, using: .fullScreen, animated: true)
            
        case .gameVC:
            let gameViewModel = GameViewModel(sceneCoordinator: self.sceneCoordinator)
            let gameScene = Scene.game(gameViewModel)
            self.sceneCoordinator.transition(to: gameScene, using: .fullScreen, animated: true)
        }
    }
    
}
