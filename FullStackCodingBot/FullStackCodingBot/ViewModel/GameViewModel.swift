import Foundation
import RxSwift
import RxCocoa
import Action

final class GameViewModel: CommonViewModel {

    // Helper Objects
    private var gameUnitManager: GameUnitManagerType
    private var timeManager: TimeManagerType
    private var timer: DispatchSourceTimer?
    
    // Game Status
    private(set) var newGameStatus = BehaviorRelay<GameStatus>(value: .ready)
    private(set) var newFeverStatus = BehaviorRelay<Bool>(value: false)
    
    // Game Properties
    private(set) var timeLeftPercentage = BehaviorRelay<Float>(value: 1)
    private(set) var feverTimeLeftPercentage = BehaviorRelay<Float>(value: 1)
    private(set) var currentScore = BehaviorSubject<Int>(value: 0)
    private(set) var newMemberUnit = BehaviorRelay<StackMemberUnit?>(value: nil)
    private(set) var newOnGameUnits = BehaviorRelay<[Unit]?>(value: nil)
    private(set) var userAction = BehaviorRelay<UserActionStatus?>(value: nil)
    
    // Actions
    private(set) lazy var pauseAction: Action<Void, Void> = Action {
        self.stopTimer()
        self.newGameStatus.accept(.pause)
        return self.toPauseScene().asObservable().map { _ in }
    }
    
    init(sceneCoordinator: SceneCoordinatorType,
         storage: PersistenceStorageType,
         database: DatabaseManagerType,
         pauseAction: CocoaAction? = nil,
         gameUnitManager: GameUnitManagerType,
         timeManager: TimeManagerType = TimeManager()) {
        self.gameUnitManager = gameUnitManager
        self.timeManager = timeManager
        super.init(sceneCoordinator: sceneCoordinator, storage: storage, database: database)
    }
}

// MARK: - Setup
extension GameViewModel {
    func execute() {
        DispatchQueue.main.asyncAfter(deadline: .now()+GameSetting.readyTime) {
            self.newGameStatus.accept(.new)
            self.setTimeManager()
            self.setGame()
            self.startTimer()
        }
    }
    
    private func setTimeManager() {
        timeManager = TimeManager()
        
        timeManager.newStart()
        
        timeManager.newTimerMode
            .subscribe(onNext: { [unowned self] timerMode in
                switch timerMode {
                case .normal:
                    self.newFeverStatus.accept(false)
                case .fever:
                    self.newFeverStatus.accept(true)
                }
        }).disposed(by: rx.disposeBag)
        
        timeManager.timeLeft
            .subscribe { [unowned self] timeLeft in
                let percentage = timePercentage(left: timeLeft, timeMode: .normal)
                self.timeLeftPercentage.accept(percentage)
        } onCompleted: { [unowned self] in
                self.gameover()
        }.disposed(by: rx.disposeBag)

        timeManager.feverTimeLeft
            .subscribe(onNext: { [unowned self] feverTimeLeft in
                guard let feverTimeLeft = feverTimeLeft else { return }
                let percentage = timePercentage(left: feverTimeLeft, timeMode: .fever)
                self.feverTimeLeftPercentage.accept(percentage)
        }).disposed(by: rx.disposeBag)
    }
    
    private func timePercentage(left: Int, timeMode: TimeMode) -> Float {
        let realTimeAdjustMent = Float(left-1)
        var totalTime: Float
        switch timeMode {
        case .normal:
            totalTime = Float(GameSetting.startingTime)
        case .fever:
            totalTime = Float(GameSetting.feverTime)
        }
        return realTimeAdjustMent / totalTime
    }
    
    private func gameover() {
        DispatchQueue.main.async {
            self.stopTimer()
            self.toGameOverScene()
        }
    }
    
    private func setGame() {
        gameUnitManager.resetAll()
        sendNewUnitToStack(by: GameSetting.startingCount)
        
        let newUnits = gameUnitManager.startings()
        newOnGameUnits.accept(newUnits)
        
        currentScore.onNext(0)
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
        guard updateScore(with: scoreGained) else { return }
        userAction.accept(.correct(direction))
        timeManager.correct()
        onGameUnitNeedsChange()
    }
    
    private func updateScore(with scoreGained: Int) -> Bool {
        guard let currentScore = try? currentScore.value() else { return false }
        let newScore = currentScore + scoreGained
        self.currentScore.onNext(newScore)
        return true
    }
    
    private func onGameUnitNeedsChange() {
        if gameUnitManager.isTimeToLevelUp(afterRaiseCountBy: 1) {
            sendNewUnitToStack(by: 1)
        }
        
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
        let currentScore = try? currentScore.value()
        let gameOverViewModel = GameOverViewModel(sceneCoordinator: sceneCoordinator, storage: storage, database: database, finalScore: currentScore ?? 0, newGameStatus: newGameStatus)
        let gameOverScene = Scene.gameOver(gameOverViewModel)
        return self.sceneCoordinator.transition(to: gameOverScene, using: .fullScreen, with: StoryboardType.game, animated: true)
    }
    
    @discardableResult
    private func toPauseScene() -> Completable {
        let currentScore = try? currentScore.value()
        let pauseViewModel = PauseViewModel(sceneCoordinator: sceneCoordinator, storage: storage, database: database, currentScore: currentScore ?? 0, newGameStatus: newGameStatus)
        let pauseScene = Scene.pause(pauseViewModel)
        return self.sceneCoordinator.transition(to: pauseScene, using: .fullScreen, with: StoryboardType.game, animated: false)
    }
}
