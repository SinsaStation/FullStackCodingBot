import Foundation
import RxSwift
import RxCocoa
import Action

final class GameViewModel: CommonViewModel {

    private(set) var newGameStatus = BehaviorRelay<GameStatus>(value: .new)
    private(set) var newFeverStatus = BehaviorRelay<Bool>(value: false)
    private var gameUnitManager: GameUnitManagerType
    private var timeManager: TimeManagerType
    private var timer: DispatchSourceTimer?
    private(set) var timeProgress = Progress(totalUnitCount: GameSetting.startingTime)
    private(set) var currentScore = 0
    private(set) var scoreAdded = BehaviorRelay<Int>(value: 0)
    private(set) var newMemberUnit = BehaviorRelay<StackMemberUnit?>(value: nil)
    private(set) var userAction = BehaviorRelay<UserActionStatus?>(value: nil)
    private(set) var newOnGameUnits = BehaviorRelay<[Unit]?>(value: nil)
    private(set) lazy var pauseAction: Action<Void, Void> = Action {
        self.stopTimer()
        self.newGameStatus.accept(.pause)
        return self.toPauseScene().asObservable().map { _ in }
    }
    
    init(sceneCoordinator: SceneCoordinatorType,
         storage: ItemStorageType,
         database: DatabaseManagerType,
         pauseAction: CocoaAction? = nil,
         gameUnitManager: GameUnitManagerType,
         timeManager: TimeManagerType = TimeManager(),
         totalTime: Int64 = GameSetting.startingTime) {
        self.gameUnitManager = gameUnitManager
        self.timeManager = timeManager
        timeProgress.becomeCurrent(withPendingUnitCount: totalTime)
        super.init(sceneCoordinator: sceneCoordinator, storage: storage, database: database)
    }
}

// MARK: - Setup
extension GameViewModel {
    func execute() {
        setTimeManager()
        setGame()
        startTimer()
    }
    
    private func setTimeManager() {
        timeManager.newStart()
        
        timeManager.newTimerMode.subscribe(onNext: { [unowned self] timerMode in
            switch timerMode {
            case .normal:
                self.newFeverStatus.accept(false)
            case .fever:
                self.newFeverStatus.accept(true)
            }
        }).disposed(by: rx.disposeBag)
        
        timeManager.timeLeft.subscribe(onNext: { [unowned self] timeLeft in
            timeProgress.completedUnitCount = Int64(timeLeft)
            self.gameMayOver(timeLeft)
        }).disposed(by: rx.disposeBag)
    }
    
    private func gameMayOver(_ timeLeft: Int) {
        guard timeLeft == 0 else { return }
        
        DispatchQueue.main.async {
            self.toGameOverScene()
            self.stopTimer()
        }
    }
    
    private func setGame() {
        gameUnitManager.resetAll()
        
        currentScore = .zero
        scoreAdded.accept(currentScore)
        
        sendNewUnitToStack(by: GameSetting.startingCount)
        let newUnits = gameUnitManager.startings()
        newOnGameUnits.accept(newUnits)
    }
    
    private func sendNewUnitToStack(by count: Int) {
        (0..<count).forEach { _ in
            let newMember = gameUnitManager.newMember()
            newMemberUnit.accept(newMember)
        }
    }
    
    func startTimer() {
        timer = DispatchSource.makeTimerSource()
        timer?.schedule(deadline: .now()+1, repeating: .seconds(GameSetting.timeUnit))
        
        timer?.setEventHandler { [weak self] in
            self?.timeManager.timeMinus(by: GameSetting.timeUnit)
        }
        timer?.activate()
    }
    
    private func stopTimer() {
        self.timer?.cancel()
    }
}

// MARK: - User Input Methods
extension GameViewModel {
    func moveUnitAction(to direction: Direction) {
        guard let currentUnitScore = gameUnitManager.currentHeadUnitScore() else { return }
        let isAnswerCorrect = gameUnitManager.isMoveActionCorrect(to: direction)
        
        isAnswerCorrect ? correctAction(for: direction, currentUnitScore) : wrongAction()
    }
    
    private func correctAction(for direction: Direction, _ scoreGained: Int) {
        userAction.accept(.correct(direction))
        currentScore += scoreGained
        scoreAdded.accept(scoreGained)
        gameUnitManager.raiseAnswerCount()
        
        if gameUnitManager.isTimeToLevelUp() { sendNewUnitToStack(by: GameSetting.timeUnit) }
        
        onGameUnitNeedsChange()
        timeManager.correct()
    }
    
    private func onGameUnitNeedsChange() {
        let currentUnits = gameUnitManager.removeAndRefilled()
        newOnGameUnits.accept(currentUnits)
    }
    
    private func wrongAction() {
        let wrongStatus = timeManager.wrong()
        userAction.accept(wrongStatus)
    }
}

// MARK: - Transitions
private extension GameViewModel {
    @discardableResult
    private func toGameOverScene() -> Completable {
        let gameOverViewModel = GameOverViewModel(sceneCoordinator: sceneCoordinator, storage: storage, database: database, finalScore: currentScore, newGameStatus: newGameStatus)
        let gameOverScene = Scene.gameOver(gameOverViewModel)
        return self.sceneCoordinator.transition(to: gameOverScene, using: .fullScreen, with: StoryboardType.game, animated: true)
    }
    
    @discardableResult
    private func toPauseScene() -> Completable {
        let pauseViewModel = PauseViewModel(sceneCoordinator: sceneCoordinator, storage: storage, database: database, currentScore: currentScore, newGameStatus: newGameStatus)
        let pauseScene = Scene.pause(pauseViewModel)
        return self.sceneCoordinator.transition(to: pauseScene, using: .fullScreen, with: StoryboardType.game, animated: false)
    }
}
