import Foundation
import RxSwift
import RxCocoa
import GameKit

final class GameOverViewModel: CommonViewModel {
    
    private var gameStoryManager: GameStoryManager
    private(set) var newScript = BehaviorRelay<Script?>(value: nil)
    private(set) var rankInfo = BehaviorRelay<String>(value: "")
    private let scoreInfo = BehaviorRelay<Int>(value: 0)
    private let moneyInfo = BehaviorRelay<Int>(value: 0)
    private(set) var highScore = BehaviorRelay<Int>(value: 0)
    private(set) var highScoreStatus = BehaviorRelay<Bool>(value: false)
    private var newGameStatus: BehaviorRelay<GameStatus>
    
    lazy var finalScore: Driver<String> = {
        return scoreInfo.map { String($0) }.asDriver(onErrorJustReturn: "")
    }()
    
    lazy var gainedMoney: Driver<String> = {
        return moneyInfo.map { String($0) }.asDriver(onErrorJustReturn: "")
    }()
    
    lazy var currentMoney: Driver<String> = {
        return storage.availableMoney().map { String($0) }.asDriver(onErrorJustReturn: "")
    }()
    
    init(sceneCoordinator: SceneCoordinatorType,
         storage: StorageType,
         finalScore: Int,
         newGameStatus: BehaviorRelay<GameStatus>,
         gameStoryManager: GameStoryManager = GameStoryManager()) {
        self.scoreInfo.accept(finalScore)
        self.moneyInfo.accept(finalScore/10)
        self.newGameStatus = newGameStatus
        self.gameStoryManager = gameStoryManager
        super.init(sceneCoordinator: sceneCoordinator, storage: storage)
    }
    
    func execute() {
        storeReward()
        updateHighScore()
        storeHightScoreToGameCenter()
        sendRank()
        sendScript()
        MusicStation.shared.stop()
    }
    
    private func storeReward() {
        storage.raiseMoney(by: moneyInfo.value)
    }
    
    private func updateHighScore() {
        let newScore = scoreInfo.value
        let isHighScore = storage.updateHighScore(new: newScore)
        highScore.accept(storage.myHighScore())
        highScoreStatus.accept(isHighScore)
    }
    
    @discardableResult
    private func storeHightScoreToGameCenter() -> Completable {
        let subject = PublishSubject<Void>()
        let bestScore = GKScore(leaderboardIdentifier: IdentifierGC.leaderboard)
        let highScore = GKScore(leaderboardIdentifier: IdentifierGC.leaderboard2)
        bestScore.value = Int64(scoreInfo.value)
        highScore.value = Int64(scoreInfo.value)
        
        GKScore.report([bestScore, highScore]) { error in
            if error != nil {
                subject.onError(AppleGameCenterError.cannotReport)
            } else {
                subject.onCompleted()
            }
        }
        return subject.ignoreElements().asCompletable()
    }
    
    private func sendRank() {
        let score = scoreInfo.value
        let currentRank = gameStoryManager.rankCharacter(for: score)
        rankInfo.accept(currentRank)
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
            sceneCoordinator.close(animated: false)
        case .mainVC:
            sceneCoordinator.toMain(animated: false)
            MusicStation.shared.play(type: .main)
        }
    }
}
