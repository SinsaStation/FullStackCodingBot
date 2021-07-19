import Foundation
import RxSwift
import RxCocoa
import Action

final class GameOverViewModel: CommonViewModel {
    
    private(set) var finalScore = BehaviorRelay<Int>(value: 0)
    private(set) var moneyGained = BehaviorRelay<Int>(value: 0)
    private var newGameStatus: BehaviorRelay<GameStatus>
    
    private(set) lazy var currentMoney: Observable<Int> = {
        return storage.availableMoeny()
    }()
    
    init(sceneCoordinator: SceneCoordinatorType, storage: ItemStorageType, finalScore: Int, newGameStatus: BehaviorRelay<GameStatus>) {
        self.finalScore.accept(finalScore)
        self.moneyGained.accept(finalScore/10)
        self.newGameStatus = newGameStatus
        super.init(sceneCoordinator: sceneCoordinator, storage: storage)
    }
    
    func execute() {
        storeReward()
    }
    
    private func storeReward() {
        storage.raiseMoney(by: moneyGained.value)
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
