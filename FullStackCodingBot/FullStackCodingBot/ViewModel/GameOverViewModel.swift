import Foundation
import RxSwift
import RxCocoa
import Action

class GameOverViewModel: CommonViewModel {
    
    private(set) var finalScore: Int
    
    init(sceneCoordinator: SceneCoordinatorType, storage: ItemStorageType, finalScore: Int) {
        self.finalScore = finalScore
        super.init(sceneCoordinator: sceneCoordinator, storage: storage)
    }
    
    func makeMoveAction(to viewController: GameOverViewControllerType) {
        switch viewController {
        case .gameVC:
            sceneCoordinator.close(animated: true)
        case .mainVC:
            sceneCoordinator.toMain(animated: true)
        }
    }
}
