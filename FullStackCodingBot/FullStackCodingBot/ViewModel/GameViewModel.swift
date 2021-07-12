import Foundation
import RxSwift
import RxCocoa
import Action

struct StackMemberUnit {
    let content: Unit
    let order: Int
    let direction: Direction
}

class GameViewModel: CommonViewModel {
    
    private var unitCount = 2
    private var unitScored = 0
    private var allUnits = [Unit]()
    private var unusedUnits = [Unit]()
    private var leftStackUnits = [Unit]()
    private var rightStackUnits = [Unit]()
    private var units = [Unit]()
    private var timer: DispatchSourceTimer?
    
    var timeProgress = Progress(totalUnitCount: Perspective.startingTime)
    let cancelAction: CocoaAction
    let score = BehaviorRelay<Int>(value: 0)
    let stackMemberUnit = BehaviorRelay<StackMemberUnit?>(value: nil)
    let logic = BehaviorRelay<Direction?>(value: nil)
    
    init(sceneCoordinator: SceneCoordinatorType, storage: ItemStorageType, cancelAction: CocoaAction? = nil) {
        self.cancelAction = CocoaAction {
            if let action = cancelAction {
                action.execute(())
            }
            return sceneCoordinator.close(animated: true).asObservable().map {_ in}
        }
        
        timeProgress.becomeCurrent(withPendingUnitCount: Perspective.startingTime)
        super.init(sceneCoordinator: sceneCoordinator, storage: storage)
    }
    
    func execute() -> [Unit] {
        resetAll()
        setUnits()
        timerStart()
        return generateStartingUnits()
    }
    
    private func resetAll() {
        unitCount = 2
        unitScored = 0
        allUnits = []
        unusedUnits = []
        leftStackUnits = []
        rightStackUnits = []
        units = []
        timeProgress.completedUnitCount = Perspective.startingTime
    }
    
    private func setUnits() {
        self.allUnits = storage.itemList()
        self.unusedUnits = allUnits.shuffled()
        
        self.leftStackUnits = [unusedUnits.removeLast()]
        sendNewStackMember(leftStackUnits[0], order: 0, to: .left)
        
        self.rightStackUnits = [unusedUnits.removeLast()]
        sendNewStackMember(rightStackUnits[0], order: 0, to: .right)
    }
    
    private func timerStart() {
        timer = DispatchSource.makeTimerSource()
        timer?.schedule(deadline: .now()+1, repeating: .seconds(1))
        timer?.setEventHandler { [weak self] in
            self?.timeProgress.completedUnitCount -= 1
            self?.gameMayOver()
        }
        timer?.activate()
    }
    
    private func sendNewStackMember(_ newMemberUnit: Unit, order: Int, to direction: Direction) {
        let newStackMember = StackMemberUnit(content: newMemberUnit, order: order, direction: direction)
        stackMemberUnit.accept(newStackMember)
    }

    private func generateStartingUnits() -> [Unit] {
        let unitsToUse = leftStackUnits + rightStackUnits
        
        (0..<Perspective.count).forEach { _ in
            units.append(unitsToUse.randomElement() ?? unitsToUse[0])
        }
        return self.units
    }
    
    func moveUnitAction(to direction: Direction) {
        let currentUnit = units[0]

        switch direction {
        case .left:
            leftStackUnits.contains(currentUnit) ? correctAction(for: .left, currentUnit) : wrongAction()
        case .right:
            rightStackUnits.contains(currentUnit) ? correctAction(for: .right, currentUnit) : wrongAction()
        }
    }
    
    private func correctAction(for direction: Direction, _ currentUnit: Unit) {
        logic.accept(direction)
        raiseScore(for: currentUnit)
    }
    
    private func wrongAction() {
        timeProgress.completedUnitCount -= Perspective.wrongTime
        gameMayOver()
    }
    
    private func gameMayOver() {
        guard timeProgress.completedUnitCount <= 0  else { return }
        timer?.cancel()

        DispatchQueue.main.async {
            self.makeMoveAction(to: .gameOverVC)
        }
    }
    
    private func raiseScore(for unit: Unit) {
        score.accept(unit.score())
        self.unitScored += 1
        
        if unitCount < Perspective.maxUnitCount && unitScored >= unitCount * 10 {
            additionalUnit()
            unitCount += 1
        }
    }
    
    private func additionalUnit() {
        let newUnit = unusedUnits.removeLast()
        
        if unitCount % 2 == 0 {
            leftStackUnits.append(newUnit)
            sendNewStackMember(newUnit, order: leftStackUnits.count-1, to: .left)
        } else {
            rightStackUnits.append(newUnit)
            sendNewStackMember(newUnit, order: rightStackUnits.count-1, to: .right)
        }
    }
    
    func newRandomUnit() -> Unit {
        units.remove(at: 0)
        let unitsToUse = leftStackUnits + rightStackUnits
        let newUnit = unitsToUse.randomElement() ?? unitsToUse[0]
        self.units.append(newUnit)
        return newUnit
    }
    
    private func makeMoveAction(to viewController: ViewControllerType) {
        switch viewController {
        case .gameOverVC:
            score.scan(0) { $0 + $1 }.bind { [weak self] finalScore in
                guard let self = self else { return }
                let gameOverViewModel = GameOverViewModel(sceneCoordinator: self.sceneCoordinator, storage: self.storage, finalScore: finalScore)
                let gameOverScene = Scene.gameOver(gameOverViewModel)
                self.sceneCoordinator.transition(to: gameOverScene, using: .fullScreen, animated: true)
            }.disposed(by: rx.disposeBag)
        default:
            assert(false)
        }
    }
}
