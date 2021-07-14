import Foundation
import RxSwift
import RxCocoa
import Action

class GameOverViewModel: CommonViewModel {
    
    private(set) var finalScore: Int
    private(set) var moneyGained: Int
    private(set) lazy var currentMoney: Observable<Int> = {
        return storage.availableMoeny()
    }()
    private var newGameStatus: BehaviorRelay<GameStatus>
    
    init(sceneCoordinator: SceneCoordinatorType, storage: ItemStorageType, finalScore: Int, newGameStatus: BehaviorRelay<GameStatus>) {
        self.finalScore = finalScore
        self.moneyGained = finalScore / 10
        self.newGameStatus = newGameStatus
        super.init(sceneCoordinator: sceneCoordinator, storage: storage)
    }
    
    func execute() {
        storeReward()
    }
    
    private func storeReward() {
        storage.raiseMoney(by: self.moneyGained)
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
