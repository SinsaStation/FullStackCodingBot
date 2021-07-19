import Foundation
import RxSwift
import RxCocoa
import Action

final class PauseViewModel: CommonViewModel {

    private(set) var currentScore = BehaviorRelay<Int>(value: 0)
    private var newGameStatus: BehaviorRelay<GameStatus>
    
    init(sceneCoordinator: SceneCoordinatorType, storage: ItemStorageType, currentScore: Int, newGameStatus: BehaviorRelay<GameStatus>) {
        self.newGameStatus = newGameStatus
        self.currentScore.accept(currentScore)
        super.init(sceneCoordinator: sceneCoordinator, storage: storage)
    }
    
    func makeMoveAction(to viewController: PauseActionType) {
        switch viewController {
        case .resume:
            newGameStatus.accept(.resume)
            sceneCoordinator.close(animated: true)
        case .restart:
            newGameStatus.accept(.new)
            sceneCoordinator.close(animated: true)
        case .toMain:
            sceneCoordinator.toMain(animated: true)
        }
    }
}
