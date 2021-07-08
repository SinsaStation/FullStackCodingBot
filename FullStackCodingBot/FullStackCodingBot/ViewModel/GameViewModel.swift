import Foundation
import RxSwift
import RxCocoa
import Action

class GameViewModel: CommonViewModel {

    let cancelAction: CocoaAction
    
    var score: Int
    private var unitCount: Int
    private var unitScored: Int
    private var allUnits: [Unit]
    private var unusedUnits: [Unit]
    private var unitsToUse: [Unit]
    var leftStackUnits: [Unit]
    var rightStackUnits: [Unit]
    private var units: [Unit]
    
    let logic = BehaviorRelay<Direction?>(value: nil)
    
    init(sceneCoordinator: SceneCoordinatorType, storage: ItemStorageType, cancelAction: CocoaAction? = nil) {
        self.cancelAction = CocoaAction {
            if let action = cancelAction {
                action.execute(())
            }
            return sceneCoordinator.close(animated: true).asObservable().map {_ in}
        }
        self.score = 0
        self.unitScored = 0
        self.unitCount = 2
        self.allUnits = []
        self.unusedUnits = []
        self.unitsToUse = []
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
        self.rightStackUnits = [unusedUnits.removeLast()]
        self.unitsToUse = leftStackUnits + rightStackUnits
    }

    private func generateStartingUnits() -> [Unit] {
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
        self.score += unit.score()
        self.unitScored += 1
    }
    
    func newRandomUnit() -> Unit {
        units.remove(at: 0)
        let newUnit = unitsToUse.randomElement() ?? unitsToUse[0]
        self.units.append(newUnit)
        return newUnit
    }
}
