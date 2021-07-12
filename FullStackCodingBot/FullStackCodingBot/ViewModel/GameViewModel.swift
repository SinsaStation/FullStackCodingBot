import Foundation
import RxSwift
import RxCocoa
import Action

class GameViewModel: CommonViewModel {
    
    private(set) var cancelAction: CocoaAction
    private var gameUnitManager: GameUnitManager?
    private var timer: DispatchSourceTimer?
    private(set) var timeProgress = Progress(totalUnitCount: Perspective.startingTime)
    var currentScore = 0
    private(set) var score = BehaviorRelay<Int>(value: 0)
    private(set) var stackMemberUnit = BehaviorRelay<StackMemberUnit?>(value: nil)
    private(set) var logic = BehaviorRelay<Direction?>(value: nil)
    
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
    
    func execute() -> [Unit] {
        newGame()
        timerStart()
        return gameUnitManager!.generateStartings()
    }
    
    private func newGame() {
        gameUnitManager?.resetAll()
        sendNewUnitToStack(by: Perspective.startingCount)
        score.accept(-currentScore)
        timeProgress.completedUnitCount = Perspective.startingTime
    }
    
    private func sendNewUnitToStack(by count: Int) {
        (0..<count).forEach { _ in
            let newMember = gameUnitManager!.newMember()
            stackMemberUnit.accept(newMember)
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
        let currentUnit = gameUnitManager!.onGames[0]
        let isAnswerCorrect = gameUnitManager!.isMoveActionCorrect(to: direction)
        isAnswerCorrect ? correctAction(for: direction, currentUnit) : wrongAction()
    }
    
    private func correctAction(for direction: Direction, _ currentUnit: Unit) {
        logic.accept(direction)
        score.accept(currentUnit.score())
        gameUnitManager!.raiseAnswerCount()
        
        if gameUnitManager!.isTimeToLevelUp() { sendNewUnitToStack(by: 1) }
    }
    
    private func wrongAction() {
        timeMinus(by: Perspective.wrongTime)
        gameMayOver()
    }
    
    func newRandomUnit() -> Unit {
        return gameUnitManager!.new()
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
