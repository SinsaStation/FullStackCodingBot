import Foundation
import RxSwift
import RxCocoa
import Action

class GameOverViewModel: CommonViewModel {
    
    private(set) var finalScore: Int
    private var newGameStatus: BehaviorRelay<GameStatus>
    
    init(sceneCoordinator: SceneCoordinatorType, storage: ItemStorageType, finalScore: Int, newGameStatus: BehaviorRelay<GameStatus>) {
        self.finalScore = finalScore
        self.newGameStatus = newGameStatus
        super.init(sceneCoordinator: sceneCoordinator, storage: storage)
    }
    
    func makeMoveAction(to viewController: GameOverViewControllerType) {
        switch viewController {
        case .gameVC:
            newGameStatus.accept(.new)
            sceneCoordinator.close(animated: true)
        case .mainVC:
            sceneCoordinator.toMain(animated: true)
        }
    }
}
