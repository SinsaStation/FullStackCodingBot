import Foundation
import RxSwift
import RxCocoa
import Action

final class GameViewModel: CommonViewModel {

    // Helper Objects
    private var gameSoundStation: GameSoundEffectStation
    private var gameUnitManager: GameUnitManagerType
    private var timeManager: TimeManagerType
    private var timer: DispatchSourceTimer?
    
    // Game Status
    private(set) var newGameStatus = BehaviorRelay<GameStatus>(value: .ready)
    private(set) var newFeverStatus = BehaviorRelay<Bool>(value: false)
    
    // Game Properties
    private(set) var timeLeftPercentage = BehaviorRelay<Double>(value: 1)
    private(set) var feverTimeLeftPercentage = BehaviorRelay<Double>(value: 1)
    private(set) var currentScore = BehaviorSubject<Int?>(value: nil)
    private(set) lazy var highScore = BehaviorRelay<Int>(value: storage.myHighScore())
    private(set) var newMemberUnit = BehaviorRelay<StackMemberUnit?>(value: nil)
    private(set) var newOnGameUnits = BehaviorRelay<[Unit]?>(value: nil)
    private(set) var userAction = BehaviorRelay<UserActionStatus?>(value: nil)
    private(set) var codeToShow = BehaviorRelay<LiveCode>(value: .matched(""))
    
    // Actions
    private(set) lazy var pauseAction: Action<Void, Void> = Action {
        self.stopTimer()
        self.newGameStatus.accept(.pause)
        return self.toPauseScene().asObservable().map { _ in }
    }
    
    init(sceneCoordinator: SceneCoordinatorType,
         storage: StorageType,
         pauseAction: CocoaAction? = nil,
         gameUnitManager: GameUnitManagerType,
         timeManager: TimeManagerType = TimeManager(),
         gameSoundStation: GameSoundEffectStation = GameSoundEffectStation()) {
        self.gameUnitManager = gameUnitManager
        self.timeManager = timeManager
        self.gameSoundStation = gameSoundStation
        super.init(sceneCoordinator: sceneCoordinator, storage: storage)
    }
}

// MARK: - Setup
extension GameViewModel {
    func execute() {
        resetAll()
        gameSoundStation.play(type: .ready)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+TimeSetting.readyTime) { [unowned self] in
            self.newGameStatus.accept(.new)
            self.setTimeManager()
            self.setGame()
            self.startTimer()
            MusicStation.shared.play(type: .game)
        }
    }
    
    private func resetAll() {
        newFeverStatus.accept(false)
        timeLeftPercentage.accept(0)
        feverTimeLeftPercentage.accept(0)
        currentScore.onNext(nil)
        newOnGameUnits.accept(nil)
        codeToShow.accept(.matched(""))
        MusicStation.shared.stop()
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
                    self.gameSoundStation.play(type: .fever)
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
    
    private func timePercentage(left: Double, timeMode: TimeMode) -> Double {
        let realTimeAdjustMent = Double(left)
        let totalTime = timeMode.totalTime
        return realTimeAdjustMent / totalTime
    }
    
    private func gameover() {
        DispatchQueue.main.async { [unowned self] in
            self.stopTimer()
            self.toGameOverScene()
            self.gameSoundStation.play(type: .gameOver)
        }
    }
    
    private func setGame() {
        let units = storage.itemList()
        gameUnitManager.reset(with: units)
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
        timer?.schedule(deadline: .now()+0.1, repeating: .milliseconds(100))
        
        timer?.setEventHandler { [weak self] in
            self?.timeManager.timeMinus(by: TimeSetting.timeUnit)
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
        guard updateScore(with: scoreGained),
              let currentUnit = gameUnitManager.completed() else { return }
        userAction.accept(.correct(direction))
        timeManager.correct()
        codeToShow.accept(.matched(currentUnit.randomCode()))
        onGameUnitNeedsChange()
        gameSoundStation.play(type: .correct)
    }
    
    private func updateScore(with scoreGained: Int) -> Bool {
        guard let currentScore = try? currentScore.value() else { return false }
        let newScore = currentScore + scoreGained
        self.currentScore.onNext(newScore)
        updateHighScore(with: newScore)
        return true
    }
    
    private func updateHighScore(with newScore: Int) {
        if newScore >= highScore.value {
            highScore.accept(newScore)
        }
    }
    
    private func onGameUnitNeedsChange() {
        if gameUnitManager.isTimeToLevelUp(afterRaiseCountBy: 1) {
            sendNewUnitToStack(by: 1)
            gameSoundStation.play(type: .levelUp)
        }
        
        let currentUnits = gameUnitManager.refilled()
        newOnGameUnits.accept(currentUnits)
    }
    
    private func wrongAction() {
        let wrongStatus = timeManager.wrong()
        userAction.accept(wrongStatus)
        gameSoundStation.play(type: .wrong)
        codeToShow.accept(.failed)
    }
}

// MARK: - Transitions
private extension GameViewModel {
    @discardableResult
    private func toGameOverScene() -> Completable {
        let currentScore = try? currentScore.value()
        let gameOverViewModel = GameOverViewModel(sceneCoordinator: sceneCoordinator, storage: storage, finalScore: currentScore ?? 0, newGameStatus: newGameStatus)
        let gameOverScene = Scene.gameOver(gameOverViewModel)
        return self.sceneCoordinator.transition(to: gameOverScene, using: .pop, with: StoryboardType.game, animated: true)
    }
    
    @discardableResult
    private func toPauseScene() -> Completable {
        let currentScore = try? currentScore.value()
        let pauseViewModel = PauseViewModel(sceneCoordinator: sceneCoordinator, storage: storage, currentScore: currentScore ?? 0, newGameStatus: newGameStatus)
        let pauseScene = Scene.pause(pauseViewModel)
        return self.sceneCoordinator.transition(to: pauseScene, using: .fullScreen, with: StoryboardType.game, animated: false)
    }
}
