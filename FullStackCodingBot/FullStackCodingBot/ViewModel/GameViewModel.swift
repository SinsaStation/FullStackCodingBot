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
    
    private var unitCount: Int
    private var unitScored: Int
    private var allUnits: [Unit]
    private var unusedUnits: [Unit]
    private var leftStackUnits: [Unit]
    private var rightStackUnits: [Unit]
    private var units: [Unit]
    
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
        self.unitScored = 0
        self.unitCount = 2
        self.allUnits = []
        self.unusedUnits = []
        self.leftStackUnits = []
        self.rightStackUnits = []
        self.units = []
        super.init(sceneCoordinator: sceneCoordinator, storage: storage)
    }
    
    func execute() -> [Unit] {
        setUnits()
        return generateStartingUnits()
    }
    
    private func setUnits() {
        self.allUnits = storage.itemList()
        self.unusedUnits = allUnits.shuffled()
        
        self.leftStackUnits = [unusedUnits.removeLast()]
        sendNewStackMember(leftStackUnits[0], order: 0, to: .left)
        
        self.rightStackUnits = [unusedUnits.removeLast()]
        sendNewStackMember(rightStackUnits[0], order: 0, to: .right)
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
            if leftStackUnits.contains(currentUnit) {
                logic.accept(.left)
                raiseScore(for: currentUnit)
            } else {
                print("틀렸음!")
            }
        case .right:
            if rightStackUnits.contains(currentUnit) {
                logic.accept(.right)
                raiseScore(for: currentUnit)
            } else {
                print("틀렸음!")
            }
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
}
