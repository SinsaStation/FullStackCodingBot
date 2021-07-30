import Foundation
import RxSwift
import RxCocoa
import Action

final class GameOverViewModel: CommonViewModel {
    
    private let scoreInfo = BehaviorRelay<Int>(value: 0)
    private let moneyInfo = BehaviorRelay<Int>(value: 0)
    private(set) var highScoreStatus = BehaviorRelay<Bool>(value: false)
    private var newGameStatus: BehaviorRelay<GameStatus>
    
    lazy var finalScore: Driver<String> = {
        return scoreInfo.map {String($0)}.asDriver(onErrorJustReturn: "")
    }()
    
    lazy var gainedMoney: Driver<String> = {
        return moneyInfo.map {String($0)}.asDriver(onErrorJustReturn: "")
    }()
    
    lazy var currentMoney: Driver<String> = {
        return storage.availableMoeny().map {String($0)}.asDriver(onErrorJustReturn: "")
    }()
    
    init(sceneCoordinator: SceneCoordinatorType, storage: PersistenceStorageType, database: DatabaseManagerType, finalScore: Int, newGameStatus: BehaviorRelay<GameStatus>) {
        self.scoreInfo.accept(finalScore)
        self.moneyInfo.accept(finalScore/10)
        self.newGameStatus = newGameStatus
        super.init(sceneCoordinator: sceneCoordinator, storage: storage, database: database)
    }
    
    func execute() {
        storeReward()
        updateHighScore()
    }
    
    private func storeReward() {
        storage.raiseMoney(by: moneyInfo.value)
    }
    
    private func updateHighScore() {
        let newScore = scoreInfo.value
        let isHighScore = storage.updateHighScore(new: newScore)
        highScoreStatus.accept(isHighScore)
    }
    
    func makeMoveAction(to viewController: GameOverViewControllerType) {
        switch viewController {
        case .gameVC:
            newGameStatus.accept(.ready)
            sceneCoordinator.close(animated: true)
        case .mainVC:
            sceneCoordinator.toMain(animated: true)
        }
    }
}
