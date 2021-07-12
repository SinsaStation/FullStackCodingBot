import Foundation
import RxSwift
import RxCocoa
import Action

class GameViewModel: CommonViewModel {
    
    private(set) var cancelAction: CocoaAction
    private var gameUnitManager: GameUnitManager?
    private var timer: DispatchSourceTimer?
    private(set) var timeProgress = Progress(totalUnitCount: Perspective.startingTime)
    private(set) var currentScore = 0
    private(set) var scoreAdded = BehaviorRelay<Int>(value: 0)
    private(set) var newMemberUnit = BehaviorRelay<StackMemberUnit?>(value: nil)
    private(set) var newDirection = BehaviorRelay<Direction?>(value: nil)
    private(set) var newOnGameUnits = BehaviorRelay<[Unit]?>(value: nil)
    
    init(sceneCoordinator: SceneCoordinatorType, storage: ItemStorageType, cancelAction: CocoaAction? = nil) {
        self.cancelAction = CocoaAction {
            if let action = cancelAction {
                action.execute(())
            }
            return sceneCoordinator.close(animated: true).asObservable().map {_ in}
        }

        gameUnitManager = GameUnitManager(allKinds: storage.itemList())
        timeProgress.becomeCurrent(withPendingUnitCount: Perspective.startingTime)
        super.init(sceneCoordinator: sceneCoordinator, storage: storage)
    }
    
    func execute() {
        newGame()
        timerStart()
        
        let newUnits = gameUnitManager?.startings()
        newOnGameUnits.accept(newUnits)
    }
    
    private func newGame() {
        gameUnitManager?.resetAll()
        sendNewUnitToStack(by: Perspective.startingCount)
        currentScore = .zero
        scoreAdded.accept(0)
        timeProgress.completedUnitCount = Perspective.startingTime
    }
    
    private func sendNewUnitToStack(by count: Int) {
        (0..<count).forEach { _ in
            let newMember = gameUnitManager?.newMember()
            newMemberUnit.accept(newMember)
        }
    }
    
    private func timerStart() {
        let timeUnit = 1
        timer = DispatchSource.makeTimerSource()
        timer?.schedule(deadline: .now()+1, repeating: .seconds(timeUnit))
        
        timer?.setEventHandler { [weak self] in
            self?.timeMinus(by: timeUnit)
            self?.gameMayOver()
        }
        timer?.activate()
    }
    
    private func timeMinus(by second: Int) {
        timeProgress.completedUnitCount -= Int64(second)
    }
    
    private func gameMayOver() {
        guard timeProgress.completedUnitCount <= 0  else { return }
        
        timer?.cancel()

        DispatchQueue.main.async {
            self.makeMoveAction(to: .gameOverVC)
        }
    }
    
    func moveUnitAction(to direction: Direction) {
        guard let gameUnitManager = gameUnitManager else { return }
        
        let currentUnitScore = gameUnitManager.onGames[0].score()
        let isAnswerCorrect = gameUnitManager.isMoveActionCorrect(to: direction)
        
        isAnswerCorrect ? correctAction(for: direction, currentUnitScore) : wrongAction()
    }
    
    private func correctAction(for direction: Direction, _ scoreGained: Int) {
        newDirection.accept(direction)
        currentScore += scoreGained
        scoreAdded.accept(scoreGained)
        gameUnitManager!.raiseAnswerCount()
        
        if gameUnitManager!.isTimeToLevelUp() { sendNewUnitToStack(by: 1) }
        
        onGameUnitNeedsChange()
    }
    
    private func onGameUnitNeedsChange() {
        let currentUnits = gameUnitManager?.removeAndRefilled()
        newOnGameUnits.accept(currentUnits)
    }
    
    private func wrongAction() {
        timeMinus(by: Perspective.wrongTime)
        gameMayOver()
    }
    
    private func makeMoveAction(to viewController: ViewControllerType) {
        switch viewController {
        case .gameOverVC:
            let gameOverViewModel = GameOverViewModel(sceneCoordinator: self.sceneCoordinator, storage: self.storage, finalScore: currentScore)
            let gameOverScene = Scene.gameOver(gameOverViewModel)
            self.sceneCoordinator.transition(to: gameOverScene, using: .fullScreen, animated: true)
        default:
            assert(false)
        }
    }
}
