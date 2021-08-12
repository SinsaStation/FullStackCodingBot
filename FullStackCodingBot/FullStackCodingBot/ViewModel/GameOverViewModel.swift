import Foundation
import RxSwift
import RxCocoa
import GameKit

final class GameOverViewModel: CommonViewModel {
    
    private var gameStoryManager: GameStoryManager
    private(set) var newScript = BehaviorRelay<Script?>(value: nil)
    private let scoreInfo = BehaviorRelay<Int>(value: 0)
    private let moneyInfo = BehaviorRelay<Int>(value: 0)
    private(set) var highScoreStatus = BehaviorRelay<Bool>(value: false)
    private var newGameStatus: BehaviorRelay<GameStatus>
    
    lazy var finalScore: Driver<String> = {
        return scoreInfo.map { String($0) }.asDriver(onErrorJustReturn: "")
    }()
    
    lazy var gainedMoney: Driver<String> = {
        return moneyInfo.map { String($0) }.asDriver(onErrorJustReturn: "")
    }()
    
    lazy var currentMoney: Driver<String> = {
        return storage.availableMoeny().map { String($0) }.asDriver(onErrorJustReturn: "")
    }()
    
    init(sceneCoordinator: SceneCoordinatorType,
         storage: PersistenceStorageType,
         database: DatabaseManagerType,
         finalScore: Int,
         newGameStatus: BehaviorRelay<GameStatus>,
         gameStoryManager: GameStoryManager = GameStoryManager()) {
        self.scoreInfo.accept(finalScore)
        self.moneyInfo.accept(finalScore/10)
        self.newGameStatus = newGameStatus
        self.gameStoryManager = gameStoryManager
        super.init(sceneCoordinator: sceneCoordinator, storage: storage, database: database)
    }
    
    func execute() {
        storeReward()
        updateHighScore()
        storeHightScoreToGameCenter()
        sendScript()
        MusicStation.shared.stop()
    }
    
    private func storeReward() {
        storage.raiseMoney(by: moneyInfo.value)
    }
    
    private func updateHighScore() {
        let newScore = scoreInfo.value
        let isHighScore = storage.updateHighScore(new: newScore)
        highScoreStatus.accept(isHighScore)
    }
    
    @discardableResult
    private func storeHightScoreToGameCenter() -> Completable {
        let subject = PublishSubject<Void>()
        let bestScore = GKScore(leaderboardIdentifier: IdentifierGC.leaderboard)
        bestScore.value = Int64(storage.myHighScore())
        
        GKScore.report([bestScore]) { error in
            if error != nil {
                subject.onError(AppleGameCenterError.cannotReport)
            } else {
                subject.onCompleted()
            }
        }
        return subject.ignoreElements().asCompletable()
    }
    
    private func sendScript() {
        let currentScore = scoreInfo.value
        let script = gameStoryManager.randomScript(for: currentScore)
        newScript.accept(script)
    }
    
    func makeMoveAction(to viewController: GameOverViewControllerType) {
        switch viewController {
        case .gameVC:
            newGameStatus.accept(.ready)
            sceneCoordinator.close(animated: true)
        case .mainVC:
            sceneCoordinator.toMain(animated: true)
            MusicStation.shared.play(type: .main)
        }
    }
}
